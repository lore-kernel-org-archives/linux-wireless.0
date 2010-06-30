Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40327 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab0F3Fqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 01:46:34 -0400
Subject: Re: Problem with firmware load on ipw2200
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4C29F711.1090306@lwfinger.net>
References: <4C29F711.1090306@lwfinger.net>
Content-Type: text/plain
Date: Wed, 30 Jun 2010 01:46:13 -0400
Message-Id: <1277876773.2536.5.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-29 at 08:37 -0500, Larry Finger wrote:
> I'm trying to help an ipw2200 user on the openSUSE Wireless Forum and I'm
> stuck. The system is failing to load the firmware with error -2 (File or
> directory not found). The difficulty is that the required files are
> present with the correct permissions.
> 
> What system component might be missing and/or borked to get this symptom?

Older versions of compat-wireless had a race condition in the firmware
code that could cause that.  From the log of the compat repository:

commit 524449c0184d44773d4947db8cd3bfd98a0a215f
Author: Grazvydas Ignotas <notasas@gmail.com>
Date:   Thu Apr 22 16:54:02 2010 +0300

    compat: fix uevent_suppress on 2.6.29 or older kernels
    
    Missing uevent_suppress is causing two uevents instead of one, which is
    confusing udev and sometimes causing firmware load to fail due to race
    condition, so let's add it.
    
    Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

-- 
Regards,
Pavel Roskin
