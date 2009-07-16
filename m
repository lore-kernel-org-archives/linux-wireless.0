Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbZGPX7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:59:19 -0400
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A5FB944.90709@mandriva.org>
References: <4A5D0374.5040702@mandriva.org>
	 <1247611024.1796.21.camel@johannes.local>  <4A5D0A7F.5090108@mandriva.org>
	 <1247672725.17896.1974.camel@rc-desk>  <4A5FA52D.7030701@mandriva.org>
	 <1247782731.31442.3.camel@johannes.local>  <4A5FB944.90709@mandriva.org>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 01:58:48 +0200
Message-Id: <1247788728.1055.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-17 at 02:35 +0300, Thomas Backlund wrote:

> > So far so good. Your platform's soft-switch is wired to the card's hard
> > kill line. Mind trying
> > 
> > 	./rfkill unblock 0
> > 
> > (or whatever ID the acer-wireless has) at this point to see what
> > happens? I would hope it goes back to the working state.
> > 
> 
> Nothing happends...
> 
> It does not change anything on either acer-wireless or phy0

Humm. Can you try this?

johannes

--- wireless-testing.orig/drivers/platform/x86/acer-wmi.c	2009-07-17 00:19:20.000000000 +0200
+++ wireless-testing/drivers/platform/x86/acer-wmi.c	2009-07-17 01:58:11.000000000 +0200
@@ -973,7 +973,7 @@ static int acer_rfkill_set(void *data, b
 {
 	acpi_status status;
 	u32 cap = (unsigned long)data;
-	status = set_u32(!!blocked, cap);
+	status = set_u32(!blocked, cap);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 	return 0;


