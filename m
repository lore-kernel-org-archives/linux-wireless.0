Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34140 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbJNJhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 05:37:00 -0400
Received: by lfaz124 with SMTP id z124so8314348lfa.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 02:36:59 -0700 (PDT)
Message-ID: <561E2239.2090006@gmail.com> (sfid-20151014_113706_663173_7705D6EB)
Date: Wed, 14 Oct 2015 11:36:57 +0200
From: Wim Torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: mac80211 and ath9k channel context
References: <20151013185055.GD50632@ubuntu-hedt>
In-Reply-To: <20151013185055.GD50632@ubuntu-hedt>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The channel context is mentioned in lots of mails and pieces of code, 
but its significance or goal is never mentioned. Could someone please be 
so kind to elaborate on this?

I believe the channel context is used to provide some hardware 
abstraction towards the driver and mac, such that virtual interfaces are 
able to work "in parallel" (to their knowledge they are the sole users) 
on the hardware, even when they use different channels. When a virtual 
interface needs to perform some action (transmission,...), the channel 
is set to the corresponding channel of the interface. Furthermore is the 
activation of virtual interfaces done in a round robin manner, where 
each channel in the channel context is activated at a periodic interval.

Is this about correct, or am I gravely mistaken?

Thanks,

Kind regards,
Wim.
