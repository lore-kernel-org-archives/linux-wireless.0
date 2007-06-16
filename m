Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:46951 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXFPR4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 13:56:00 -0400
Received: from dsl092-162-116.wdc2.dsl.speakeasy.net (HELO m5.risacher.org) ([66.92.162.116])
          (envelope-sender <magnus@alum.mit.edu>)
          by mail4.sea5.speakeasy.net (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 16 Jun 2007 17:49:19 -0000
Received: from magnus by m5.risacher.org with local (Exim 4.67)
	(envelope-from <magnus@alum.mit.edu>)
	id 1HzcOj-0002jC-9g
	for linux-wireless@vger.kernel.org; Sat, 16 Jun 2007 13:49:17 -0400
To: linux-wireless@vger.kernel.org
Subject: rtl8187b support?
From: Daniel Risacher <magnus@alum.mit.edu>
Date: Sat, 16 Jun 2007 13:49:17 -0400
Message-ID: <87bqff94de.fsf@m5.risacher.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Is there anyone working on rtl8187b support, or any institutional
wisdom about this chip?

I recently purchased a Trendnet usb wifi adapter - TEW-424UB HWv3.0.
It shows up as VendorID 0x0bda and ProductID 0x8189, and when opened
has a rtl8187b inside.  The drivers from the git wireless-dev branch
do not recognize this device.  I added the 0x8189 ProductID to
wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c, just
to see if it would work, but this caused a panic when the driver
loaded.

Realtek has a linux driver available at
http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=24&PFid=1&Level=6&Conn=5&DownTypeID=3&GetDown=false&Downloads=true
(see the very bottom), which is based on Andrea Merello's code circa
2005, but this doesn't compile with recent kernels - and incidentally
is painful to cross compile. (I'm building for armv4l).

Any thoughts or insight on how to get this to work?

---
Daniel Risacher                                  magnus@alum.mit.edu
