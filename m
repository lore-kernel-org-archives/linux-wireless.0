Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:36525 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbcBLAcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 19:32:03 -0500
Received: by mail-vk0-f54.google.com with SMTP id c3so49934383vkb.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2016 16:32:02 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Feb 2016 16:32:02 -0800
Message-ID: <CAHWMYyDphLy2KGKuCKq-R9t6NVyjSF18WpA-emc9eZcSY30mZg@mail.gmail.com> (sfid-20160212_013210_211514_10210198)
Subject: Rate Control Tuning/Information
From: Todd Efflam <todd.efflam@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
We're currently trying to tune the rate control algorithm (minstrel)
with our video encoding quality.  We're using a udp network so ideally
the two will match up and we won't be trying to encode at too high of
a quality when our data rate is decreased.

In doing so, I have a couple of questions:
a) Is it possible to change the timing between rate changes?  We'd
like to not change in the middle of encoding a video frame and give
our encoding enough time to create a frame that will fit in the
current data rate.
b) Is there a better way to get the current data rate than using
iwconfig?  Or possibly an interrupt for when the data rate is changed
so we can change our encoding quality to match it as soon as possible?
c) If the above aren't possible, is the best way to manually change
the data rate by configuring the kernel to not use rate control and
send rate change requests via something like "echo 'index' >
/sys/kernel/debug/ieee80211/phy0/rc/fixed_rate_idx" (posted here:
http://unix.stackexchange.com/questions/182520/disable-rate-control-in-linux-wireless-driver).

Any advice is appreciated!  Thank you.

Best,
Todd
