Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44406 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3FNSVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 14:21:25 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc8so823740pbc.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 11:21:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B7A9FB.9020706@erley.org>
References: <CA+7oyge=p5uTgCc+Veq-fZrH2Dd6Ew7OR8m0mz+e7+Ze+LNcYQ@mail.gmail.com>
	<51B7A9FB.9020706@erley.org>
Date: Fri, 14 Jun 2013 14:21:25 -0400
Message-ID: <CA+7oyge65d5aMnYKMR+4-E4UzaaGyUMRF9h9UfOecKbgqMcsVQ@mail.gmail.com> (sfid-20130614_202129_856558_DC39332F)
Subject: Re: where is ath9k debugfs?
From: George Nychis <gnychis@gmail.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pat,

You're correct on this.  I always seem to forget about the distinction
between ath9k and ath_htc.  Thanks a bunch!

- George

On Tue, Jun 11, 2013 at 6:51 PM, Pat Erley <pat-lkml@erley.org> wrote:
> On 06/11/2013 12:40 PM, George Nychis wrote:
>>
>> I have configured my kernel to use ath9k debugfs:
>> $ grep ATH9K_DEBUGFS /boot/config-`uname -r`
>> CONFIG_ATH9K_DEBUGFS=y
>>
>> The location of these debugfs files should be in
>> /sys/kernel/debug/ath9k according to:
>>
>> http://wireless.kernel.org/en/users/Drivers/ath9k/debug#Debugfs_files_for_ath9k
>>
>> However, when I load the modules and plug in an ath9k device, I do not
>> get any ath9k debugfs files:
>> root@parallels:/sys# find /sys -name ath9k
>> root@parallels:/sys# find /sys -name rx_chainmask
>> root@parallels:/sys# find /sys -name disable_ani
>> root@parallels:/sys#
>>
>> I do get the ieee80211 debug, though:
>> # ls -l /sys/kernel/debug/ieee80211/
>> total 0
>> drwxr-xr-x 6 root root 0 Jun 11 12:30 phy0
>>
>> Do I need to pass some parameter to the kernel module on load to get
>> the ath9k debugfs?  Am I missing something else?
>>
>> Thanks!
>> George
>
>
> Hi George,
>
> When you say 'plug in an ath9k device' I assume you mean you plug it in
> before you boot?  There aren't any ath9k devices that I know of that use
> USB.  I believe they're all handled by ath9k_htc.
>
> Aside from that, you found the right spot (/sys/kernel/debug/ieee80211/phyN)
> for it to live.  What does dmesg say when you plug in/boot with the device?
>
> Pat
