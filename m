Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23102.mail.ird.yahoo.com ([217.146.189.42]:26263 "HELO
	web23102.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541AbYKAAwL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 20:52:11 -0400
Date: Sat, 1 Nov 2008 00:52:09 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: suspend/hibernate/resume code in wireless drivers.
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <490B957E.8020406@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <624811.768.qm@web23102.mail.ird.yahoo.com> (sfid-20081101_015258_166316_7A3326DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am just experiencing a problem I read about but I thought I didn't have.
I have always been able to suspend/resume without unloading the rtl8187 module ever since it started to work reasonably well. It seems that there is some automatic mechanism for unloading any usb network driver which does not have its own suspend/resume code. But it doesn't work in 2.6.27. 

(I filed this as https://bugzilla.redhat.com/show_bug.cgi?id=469461, and there is a reference to an upstream bug report).

Anyway, I think this is the likely breakage?

--------------
commit 78d9a487ee961c356e1a934d9a92eca38ffb3a70
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Jun 23 16:00:40 2008 -0400

    USB: Force unbinding of drivers lacking reset_resume or other methods
    
    This patch (as1024) takes care of a FIXME issue: Drivers that don't
    have the necessary suspend, resume, reset_resume, pre_reset, or
    post_reset methods will be unbound and their interface reprobed when
    one of the unsupported events occurs.
    
    This is made slightly more difficult by the fact that bind operations
    won't work during a system sleep transition.  So instead the code has
    to defer the operation until the transition ends.
    
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
-----------------

Any thought on this?

Hin-Tak


      
