Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34722 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1IFGV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 02:21:28 -0400
Received: by yie30 with SMTP id 30so3776361yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 23:21:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315213334.4075.4.camel@jlt3.sipsolutions.net>
References: <1315123892-5031-1-git-send-email-arik@wizery.com> <1315213334.4075.4.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 6 Sep 2011 09:21:13 +0300
Message-ID: <CA+XVXfeALowe=Nd1YgNgZt65=7czsCraoJjxSX_7fybtfTAUsQ@mail.gmail.com> (sfid-20110906_082136_428002_F8E04BA9)
Subject: Re: [PATCH v2] mac80211: add ssid config to bss information in AP-mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 5, 2011 at 12:02, Johannes Berg <johannes@sipsolutions.net> wrote:
>>  struct ieee80211_bss_conf {
>>       const u8 *bssid;
>> @@ -280,6 +285,9 @@ struct ieee80211_bss_conf {
>>       bool arp_filter_enabled;
>>       bool qos;
>>       bool idle;
>> +     u8 ssid[IEEE80211_MAX_SSID_LEN];
>> +     size_t ssid_len;
>> +     bool hidden_ssid;
>
> I guess the reason you don't use the nl80211 enum here is that the
> device doesn't care since the beacon is built by hostapd/mac80211 and
> entirely transparent to the device?

exactly.

>
>> +static void ieee80211_config_ap_ssid(struct ieee80211_sub_if_data
>> *sdata,
>> +                                    struct beacon_parameters *params)
>
> Any particular reason for not just inlining the few code lines?

I figured ieee80211_config_beacon() was too long as it is.

>
>
> However, what's this used for? Didn't we discuss this before and decide
> that there's no clear way to implement probe response offloading given
> the possibility that WPS, P2P and similar protocols that use probe
> request/response handshaking could be in use?

The FW treats WPS, P2P probe-requests as special cases and passes them
to the host without replying. This works well and passes all required
tests.
As discussed on IRC, in the future we'll have to add feature flags for
these cards, to let hostapd know about the offloading.

Arik
