Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbcDNVLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 17:11:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 00/16] rtl8xxxu - additional fixes
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
	<571002AA.9020602@lwfinger.net>
Date: Thu, 14 Apr 2016 17:11:36 -0400
In-Reply-To: <571002AA.9020602@lwfinger.net> (Larry Finger's message of "Thu,
	14 Apr 2016 15:50:50 -0500")
Message-ID: <wrfjpotrevzr.fsf@redhat.com> (sfid-20160414_231141_126774_B5BAD11D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 04/14/2016 03:37 PM, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Hi,
>>
>> This is a second set of rtl8xxxu related patches, which goes on top of
>> the set I sent out earlier today. If you only have time to go through
>> one set, please look at the other set.
>>
>> This set primarily contains fixes to make rtl8188ru v2 devices work
>> again. I have reports that v1 devices still don't work, but I don't
>> have one of those, so I am not able to test this.
>>
>> This also includes a fix for a crash reported by Xose Vazquez Peres
>> when trying to hot add a USB ID. It marks 0x050d:0x1004 as tested,
>> reported by Andrea Merello, and handles an old bug where the
>> driver didn't unregister from mac80211 before shutting down the
>> device. Last it includes a uninitialized return value fix from Colin
>> Ian King.
>
> I can confirm that the rtl8188ru v1 devices still do not work. Using
> "iwlist scan", my APs at 2m have signal levels from -90 to -98 dBm. I
> do not know if it is a problem in setting the gain, or if the antenna
> selection is wrong.
>
> By the way, I have the same problem with the rtl8723bu device.

Note that the Realtek devices don't allow you to set gains for RX, only
for TX power.

For the 8723bu it works for me if I remove the device, reload the
driver, restart NetworkMangler, then insert the device. There is
something in the device reset code that doesn't work right at the
moment, but I haven't figured it out yet.

The 8188ru v1 issue is likely different from the 8723bu issue though.

I also won't guarantee you can trust the signal levels reported by
iwlist scan .... it's possible I haven't implemented all of that yet,
but I could be wrong there.

In either case, support for some usage is better than no usage, until we
figure out the remaining problems :)

Cheers,
Jes
