Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35159 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbAGJGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 04:06:52 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so778183wgh.18
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 01:06:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87lhm3iusl.fsf@kamboji.qca.qualcomm.com>
References: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
	<1418829711-19713-6-git-send-email-bartosz.markowski@tieto.com>
	<87lhm3iusl.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 7 Jan 2015 10:06:51 +0100
Message-ID: <CA+BoTQmJ3Z0LvBKb9ibpqR=YX_boMRTuvoU58-UJQt6+1mRGzg@mail.gmail.com> (sfid-20150107_100700_750532_3917BC52)
Subject: Re: [PATCH 5/5] ath10k: implement support for ap beacon offloading
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Bartosz Markowski <bartosz.markowski@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 December 2014 at 15:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> From: Michal Kazior <michal.kazior@tieto.com>
>>
>> New firmware revisions support beacon and probe
>> response templates instead. This means SWBA events
>> are no longer delivered for these firmware
>> revisions.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +     ret = ath10k_mac_setup_bcn_p2p_ie(arvif, bcn);
>> +     if (ret) {
>> +             ath10k_warn(ar, "failed to setup p2p go bcn ie: %d\n", ret);
>> +             kfree_skb(bcn);
>> +             return ret;
>> +     }
>> +
>> +     ath10k_mac_remove_vendor_ie(bcn, WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P,
>> +                                 offsetof(struct ieee80211_mgmt,
>> +                                          u.beacon.variable));
>
> A comment would be nice why you are removing the P2P IE. I guess because
> there's a different command to set that IE?

Correct - ath10k_wmi_p2p_go_bcn_ie() (called by
ath10k_mac_setup_bcn_p2p_ie) is that command. The removal avoids
duplicate P2P IE in Beacons. I'll add a comment.


Michał
