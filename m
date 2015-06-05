Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37733 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbFEJqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 05:46:04 -0400
Received: by wifx6 with SMTP id x6so14680451wif.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 02:46:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <01f701d09f71$47ae9910$d70bcb30$@acksys.fr>
References: <01eb01d09f64$fd522730$f7f67590$@acksys.fr>
	<CA+BoTQnehkYETptdaw4VsqKmhAampJ9_Zm_bNfH6PwGX7SqRww@mail.gmail.com>
	<01f701d09f71$47ae9910$d70bcb30$@acksys.fr>
Date: Fri, 5 Jun 2015 11:46:03 +0200
Message-ID: <CA+BoTQkQyTbgctPOTSvLH76+YKkjvYySJSYtGszJ3TT35-uXQQ@mail.gmail.com> (sfid-20150605_114608_921175_356AE401)
Subject: Re: ATH10K and VLAN : Frame with VLAN tag are not sent
From: Michal Kazior <michal.kazior@tieto.com>
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 June 2015 at 11:23, voncken <cedric.voncken@acksys.fr> wrote:
[...]
>> I see no reason why this should fail. The dot1q encapsulation shouldn't
>> influence how firmware behaves.. but maybe I'm wrong.
>>
>> It's still unclear to me what your topology looks like. Perhaps you're
>> having problem with environmental configuration itself? Did you try other
>> Wi-Fi device (e.g. ath9k) instead of ath10k?
> Yes I tested with ath9k wireless card, the same configuration works.
>
> I did an interesting test. With ostinato software I generate an ICMP frame without vlan tag. I changed the ethertype in the frame.
> I tried with the ethertype 0x800 (IP), 0x801, 0x8892 (PROFINET), 0x8100 (dot1q), 0x0600. All frames are sent except when the ethertype is set to 0x8100. It seems the firmware do not accept the ethertype 0x8100.

Interesting. This may suggest firmware actually doesn't handle dot1q
VLAN tagging properly in NWifi Tx encap mode. Can you try changing it
to 802.3 encap and re-test, please?

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3172,7 +3172,7 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct
ieee80211_vif *vif,
        if (ieee80211_is_data_present(fc) && sta && sta->tdls)
                return ATH10K_HW_TXRX_ETHERNET;

-       return ATH10K_HW_TXRX_NATIVE_WIFI;
+       return ATH10K_HW_TXRX_ETHERNET;
 }

Note: Your backports may not have the necessary code.. In which case
it'll be difficult to do this the easy way. If that's the case I
suggest you get latest backports or generate them yourself from the
latest kvalo/ath master.


Michał
