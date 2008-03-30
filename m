Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:21088 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYC3N2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 09:28:32 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1345801fgb.17
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2008 06:28:30 -0700 (PDT)
To: Bas Hulsken <bhulsken@hotmail.com>
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
Date: Sun, 30 Mar 2008 15:27:34 +0200
Cc: Adam Baker <linux@baker-net.org.uk>, linux-wireless@vger.kernel.org
References: <1206801246.24689.19.camel@Bas> <loom.20080329T232927-720@post.gmane.org> <1206882945.4973.5.camel@Bas>
In-Reply-To: <1206882945.4973.5.camel@Bas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803301527.34583.IvDoorn@gmail.com> (sfid-20080330_142842_647364_F7CC9D5E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Ivo,
> > Don't forget that there was no response to the request for someone to test
> > if broadcast packets were received in monitor mode on the older hardware
> > so if the filter flags don't select multicast traffic we could be losing
> > broadcast traffic too. I'm not sure if the stack will be reporting any
> > active multicast groups in AP mode. (For the benefit of others the only
> > reason normal broadcast traffic was working was because there was always a
> > multicast group present, Ivo's request is linked below.)
> > 
> > http://sourceforge.net/mailarchive/forum.php?thread_name=200803031921.41634.IvDoorn%40gmail.com&forum_name=rt2400-devel
> > 
> I would like to test for this, but I'm not quite sure how, I've read
> Ivo's original message, but I can't find the monitoring bug discussion
> Ivo is referring to. Would the frame captures on debugfs, again with the
> above mentioned tools test for this bug as well? Or is there something
> else I have to do?

So far I have received 1 result for the above test request which indicated rt2500pci
wasn't harmed with this bug. However, latest rt2x00 has Adam's patch active for
all rt2x00 drivers (since the code is now handled in rt2x00mac.c).
So this means that that multicast bug should have no influence for this bug.

Ivo
