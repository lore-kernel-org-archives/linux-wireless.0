Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33697 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2H3P7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 11:59:18 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so1364316qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2012 08:59:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120807102208.GA12589@redhat.com>
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
 <20120807102208.GA12589@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Thu, 30 Aug 2012 16:58:58 +0100
Message-ID: <CAJZjf_xVOKjVYYXxsWf6Z+KaTDi_3ZDqvBMyzMETfbkpWUgWFQ@mail.gmail.com> (sfid-20120830_175943_448519_E56D2A4A)
Subject: Re: unloading WiFi modules is usually triggering kernel crash
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 7, 2012 at 11:22 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Jul 31, 2012 at 01:54:52PM +0100, Pedro Francisco wrote:
>> I've noticed in the past few days a pattern: sometimes nm-applet
>> starts showing empty bars for the signal strength.
>
> RSSI reporting problem or maybe NM issue. When you change kernel to
> older or newer does this problem go away ?
>
>> Running the script:
>> sudo ifconfig wlan0 down; sleep 1
>> sudo rmmod hp_wmi; sudo rmmod iwl3945; sudo rmmod iwlegacy; sudo rmmod
>> mac80211; sudo rmmod cfg80211
>> sleep 2; sudo rmmod rfkill; sync
>> sudo modprobe rfkill; sudo modprobe cfg80211; sudo modprobe mac80211;
>> sudo modprobe iwlegacy
>> sudo modprobe iwl3945; sudo modprobe hp_wmi; sleep 1; sudo ifconfig wlan0 up
>
> I run a bit modified script (I do not have hp_wmi.ko and rfkill.ko) for few
> hours, and did not get any WARNING/crash. I used 3.5, can you check if that
> problem is also fixed on your system on 3.5 or newer.

On 3.5.2-3.fc17.i686.PAE everything seems stable. The problem I had
described hasn't happened recently.
I guess it got fixed in the meantime.

Thank you for your time,
-- 
Pedro
