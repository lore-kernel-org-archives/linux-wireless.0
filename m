Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477AbZGPWbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 18:31:06 -0400
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1247782731.31442.3.camel@johannes.local>
References: <4A5D0374.5040702@mandriva.org>
	 <1247611024.1796.21.camel@johannes.local>  <4A5D0A7F.5090108@mandriva.org>
	 <1247672725.17896.1974.camel@rc-desk>  <4A5FA52D.7030701@mandriva.org>
	 <1247782731.31442.3.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 00:30:33 +0200
Message-Id: <1247783433.31442.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-17 at 00:18 +0200, Johannes Berg wrote:

> > And pressing it again gets this:
> > [root@tmb-laptop rfkill]# ./rfkill list
> > 0: acer-wireless: Wireless LAN
> > 	Soft blocked: no
> > 	Hard blocked: no
> > 1: acer-bluetooth: Bluetooth
> > 	Soft blocked: yes
> > 	Hard blocked: no
> > 2: phy0: Wireless LAN
> > 	Soft blocked: yes
> > 	Hard blocked: no
> > 
> > And after that I cant get wireless back until I again do a:
> > ./rfkill unblock 2
> > (works only when acer-wireless is no/no and Wireless LAN is yes/no)
> 
> Right. This is bad. The button press shouldn't have affected the
> soft-state of the rfkill #2.
> 
> > Applying this patch:
> > [PATCH] rfkill: fix rfkill_set_states() to set the hw state
> > sent by Alan Jenkins does not help this issue either...
> > 
> > Any  suggestions how to fix the rfkill ?
> 
> I'll poke at the acer code to see what it's doing wrong...

Can't see anything wrong. I wonder if the button you have sends both the
ACPI event _and_ an input event.

Can you try this patch and tell us what happens?

johannes

--- wireless-testing.orig/net/rfkill/input.c	2009-07-17 00:27:29.000000000 +0200
+++ wireless-testing/net/rfkill/input.c	2009-07-17 00:29:50.000000000 +0200
@@ -57,6 +57,8 @@ static void __rfkill_handle_global_op(en
 {
 	unsigned int i;
 
+	printk(KERN_DEBUG "__rfkill_handle_global_op(%d)\n", op);
+
 	switch (op) {
 	case RFKILL_GLOBAL_OP_EPO:
 		rfkill_epo();
@@ -87,6 +89,7 @@ static void __rfkill_handle_normal_op(co
 	bool blocked;
 
 	blocked = rfkill_get_global_sw_state(type);
+	printk(KERN_DEBUG "__rfkill_handle_normal_op(%d, %d) [%d]\n", type, complement, blocked);
 	if (complement)
 		blocked = !blocked;
 
@@ -175,6 +178,8 @@ static void rfkill_schedule_toggle(enum 
 {
 	unsigned long flags;
 
+	printk(KERN_DEBUG "rfkill_schedule_toggle(%d)\n", type);
+
 	if (rfkill_is_epo_lock_active())
 		return;
 
@@ -189,6 +194,8 @@ static void rfkill_schedule_toggle(enum 
 
 static void rfkill_schedule_evsw_rfkillall(int state)
 {
+	printk(KERN_DEBUG "rfkill_schedule_evsw_rfkillall(%d)\n", state);
+
 	if (state)
 		rfkill_schedule_global_op(rfkill_master_switch_op);
 	else


