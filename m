Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:38839 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3FIA2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jun 2013 20:28:37 -0400
Received: by mail-qc0-f182.google.com with SMTP id e10so769706qcy.13
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jun 2013 17:28:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130603141804.GA2146@redhat.com>
References: <20120418203543.GA16000@x61.home> <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home> <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com> <20130603085239.GA26920@mac.home> <20130603141804.GA2146@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Sun, 9 Jun 2013 01:28:16 +0100
Message-ID: <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com> (sfid-20130609_022848_464693_20E47170)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 3, 2013 at 3:18 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jun 03, 2013 at 10:52:39AM +0200, Tino Keitel wrote:
>> On Mon, Jan 07, 2013 at 12:08:00 +0100, Stanislaw Gruszka wrote:
>>
>> [...]
>>
>> > I posted patch here
>> > http://marc.info/?l=linux-wireless&m=135601033021616&w=2
>> >
>> > But I did not review code regarding power save to catch possible
>> > problems. Testing are bug reporting are welcome ...
>>
>> Hi,
>>
>> the patch is surprisingly small. To me it looks like it only contains
>> the code to make "iwconfig wlan0 power on" work, the actual power
>> management is missing.
>>
>> I just did some tests using powertop to see if I'm right. With the old
>> pre-iwlegacy driver, the difference between "iwconfig wlan0 power on"
>> and "...  power off" is more then 0,8W, which is ~10% of the total idle
>> power usage of my X61s with dimmed screen.  With a current kernel and
>> your patch, I can't measure a difference between "iwconfig wlan0 power
>> on" and "...  power off".  To me it seems that the patch is pretty
>> useless, at least on 4965AGN hardware.
>
> Yes, we do not send any command to put hardware in sleep mode when
> mac80211 enable PS.
>
>> It would be really nice to have proper power management in a current
>> kernel, as the laptop gets noticeably hotter with the current iwlegacy
>> driver.  That's why I still use a 3.1.10 kernel with an old
>> forward-ported iwlagn driver.
>
> Could you try this experimental patch? (...)

I am trying the iwlegacy powersave patch along with CPU scheduler BFS
and IO scheduler BFQ.

I've got this today:

Jun 09 00:51:34 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 51 is out of range [0-256] 51 51
Jun 09 00:51:34 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 52 is out of range [0-256] 51 51
(...)
Jun 09 00:51:38 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 219 is out of range [0-256] 57 51
Jun 09 00:51:38 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 220 is out of range [0-256] 57 51

Jun 09 00:51:34 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 51 is out of range [0-256] 51 51
Jun 09 00:51:34 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 52 is out of range [0-256] 51 51
(...)
Jun 09 00:51:38 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 254 is out of range [0-256] 58 51
Jun 09 00:51:38 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 255 is out of range [0-256] 58 51
Jun 09 00:51:38 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 0 is out of range [0-256] 58 51
Jun 09 00:51:38 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 1 is out of range [0-256] 58 51
(...)
Jun 09 00:51:39 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 49 is out of range [0-256] 58 51
Jun 09 00:51:39 s2 kernel: iwl3945 0000:02:00.0: Read idx for DMA
queue txq_id (2) idx 50 is out of range [0-256] 58 51

$ uname -a
Linux s2 3.9.4-301.local.fc19.i686

I have just made a clean boot (as in, this has not happened after a
resume for suspend or hibernation).

May it be related to the patch? Or may heavy IO with out-of-tree CPU
scheduler BFS and out-of-tree IO scheduler BFQ be responsible for the
warnings?

Thanks in Advance,
-- 
Pedro Francisco
