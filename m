Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761746AbYBZPkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:40:00 -0500
Subject: [PATCH] mac80211: add documentation book
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 14:34:06 +0100
Message-Id: <1204032846.13162.221.camel@johannes.berg> (sfid-20080226_154007_280436_222DEF02)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quite a while ago I started this book. The required kernel-doc
patches have since gone into the tree so it is now possible to
build the book in mainline.

The actual documentation is still rather incomplete and not all
things are linked into the book, but this enables us to edit
the documentation collaboratively, hopefully driver authors can
add documentation based on their experience with mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/DocBook/Makefile      |    3 
 Documentation/DocBook/mac80211.tmpl |  335 ++++++++++++++++++++++++++++++++++++
 include/net/mac80211.h              |    7 
 net/mac80211/key.c                  |    4 
 net/mac80211/sta_info.c             |   16 -
 5 files changed, 351 insertions(+), 14 deletions(-)

--- everything.orig/Documentation/DocBook/Makefile	2008-02-26 14:29:57.000000000 +0100
+++ everything/Documentation/DocBook/Makefile	2008-02-26 14:29:59.000000000 +0100
@@ -11,7 +11,8 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
 	    procfs-guide.xml writing_usb_driver.xml networking.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml
+	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
+	    mac80211.xml
 
 ###
 # The build process is as follows (targets):
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/Documentation/DocBook/mac80211.tmpl	2008-02-26 14:29:59.000000000 +0100
@@ -0,0 +1,335 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="mac80211-developers-guide">
+  <bookinfo>
+    <title>The mac80211 subsystem for kernel developers</title>
+
+    <authorgroup>
+      <author>
+        <firstname>Johannes</firstname>
+        <surname>Berg</surname>
+        <affiliation>
+          <address><email>johannes@sipsolutions.net</email></address>
+        </affiliation>
+      </author>
+    </authorgroup>
+
+    <copyright>
+      <year>2007</year>
+      <year>2008</year>
+      <holder>Johannes Berg</holder>
+    </copyright>
+
+    <legalnotice>
+      <para>
+        This documentation is free software; you can redistribute
+        it and/or modify it under the terms of the GNU General Public
+        License version 2 as published by the Free Software Foundation.
+      </para>
+
+      <para>
+        This documentation is distributed in the hope that it will be
+        useful, but WITHOUT ANY WARRANTY; without even the implied
+        warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+        See the GNU General Public License for more details.
+      </para>
+
+      <para>
+        You should have received a copy of the GNU General Public
+        License along with this documentation; if not, write to the Free
+        Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+        MA 02111-1307 USA
+      </para>
+
+      <para>
+        For more details see the file COPYING in the source
+        distribution of Linux.
+      </para>
+    </legalnotice>
+
+    <abstract>
+!Pinclude/net/mac80211.h Introduction
+!Pinclude/net/mac80211.h Warning
+    </abstract>
+  </bookinfo>
+
+  <toc></toc>
+
+<!--
+Generally, this document shall be ordered by increasing complexity.
+It is important to note that readers should be able to read only
+the first few sections to get a working driver and only advanced
+usage should require reading the full document.
+-->
+
+  <part>
+    <title>The basic mac80211 driver interface</title>
+    <partintro>
+      <para>
+        You should read and understand the information contained
+        within this part of the book while implementing a driver.
+        In some chapters, advanced usage is noted, that may be
+        skipped at first.
+      </para>
+      <para>
+        This part of the book only covers station and monitor mode
+        functionality, additional information required to implement
+        the other modes is covered in the second part of the book.
+      </para>
+    </partintro>
+
+    <chapter id="basics">
+      <title>Basic hardware handling</title>
+      <para>TBD</para>
+      <para>
+        This chapter shall contain information on getting a hw
+        struct allocated and registered with mac80211.
+      </para>
+      <para>
+        Since it is required to allocate rates/modes before registering
+        a hw struct, this chapter shall also contain information on setting
+        up the rate/mode structs.
+      </para>
+      <para>
+        Additionally, some discussion about the callbacks and
+        the general programming model should be in here, including
+        the definition of ieee80211_ops which will be referred to
+        a lot.
+      </para>
+      <para>
+        Finally, a discussion of hardware capabilities should be done
+        with references to other parts of the book.
+      </para>
+<!-- intentionally multiple !F lines to get proper order -->
+!Finclude/net/mac80211.h ieee80211_hw
+!Finclude/net/mac80211.h ieee80211_hw_flags
+!Finclude/net/mac80211.h SET_IEEE80211_DEV
+!Finclude/net/mac80211.h SET_IEEE80211_PERM_ADDR
+!Finclude/net/mac80211.h ieee80211_ops
+!Finclude/net/mac80211.h ieee80211_alloc_hw
+!Finclude/net/mac80211.h ieee80211_register_hw
+!Finclude/net/mac80211.h ieee80211_get_tx_led_name
+!Finclude/net/mac80211.h ieee80211_get_rx_led_name
+!Finclude/net/mac80211.h ieee80211_get_assoc_led_name
+!Finclude/net/mac80211.h ieee80211_get_radio_led_name
+!Finclude/net/mac80211.h ieee80211_unregister_hw
+!Finclude/net/mac80211.h ieee80211_free_hw
+    </chapter>
+
+    <chapter id="phy-handling">
+      <title>PHY configuration</title>
+      <para>TBD</para>
+      <para>
+        This chapter should describe PHY handling including
+        start/stop callbacks and the various structures used.
+      </para>
+!Finclude/net/mac80211.h ieee80211_conf
+!Finclude/net/mac80211.h ieee80211_conf_flags
+    </chapter>
+
+    <chapter id="iface-handling">
+      <title>Virtual interfaces</title>
+      <para>TBD</para>
+      <para>
+        This chapter should describe virtual interface basics
+        that are relevant to the driver (VLANs, MGMT etc are not.)
+        It should explain the use of the add_iface/remove_iface
+        callbacks as well as the interface configuration callbacks.
+      </para>
+      <para>Things related to AP mode should be discussed there.</para>
+      <para>
+        Things related to supporting multiple interfaces should be
+        in the appropriate chapter, a BIG FAT note should be here about
+        this though and the recommendation to allow only a single
+        interface in STA mode at first!
+      </para>
+!Finclude/net/mac80211.h ieee80211_if_types
+!Finclude/net/mac80211.h ieee80211_if_init_conf
+!Finclude/net/mac80211.h ieee80211_if_conf
+    </chapter>
+
+    <chapter id="rx-tx">
+      <title>Receive and transmit processing</title>
+      <sect1>
+        <title>what should be here</title>
+        <para>TBD</para>
+        <para>
+          This should describe the receive and transmit
+          paths in mac80211/the drivers as well as
+          transmit status handling.
+        </para>
+      </sect1>
+      <sect1>
+        <title>Frame format</title>
+!Pinclude/net/mac80211.h Frame format
+      </sect1>
+      <sect1>
+        <title>Alignment issues</title>
+        <para>TBD</para>
+      </sect1>
+      <sect1>
+        <title>Calling into mac80211 from interrupts</title>
+!Pinclude/net/mac80211.h Calling mac80211 from interrupts
+      </sect1>
+      <sect1>
+        <title>functions/definitions</title>
+!Finclude/net/mac80211.h ieee80211_rx_status
+!Finclude/net/mac80211.h mac80211_rx_flags
+!Finclude/net/mac80211.h ieee80211_tx_control
+!Finclude/net/mac80211.h ieee80211_tx_status_flags
+!Finclude/net/mac80211.h ieee80211_rx
+!Finclude/net/mac80211.h ieee80211_rx_irqsafe
+!Finclude/net/mac80211.h ieee80211_tx_status
+!Finclude/net/mac80211.h ieee80211_tx_status_irqsafe
+!Finclude/net/mac80211.h ieee80211_rts_get
+!Finclude/net/mac80211.h ieee80211_rts_duration
+!Finclude/net/mac80211.h ieee80211_ctstoself_get
+!Finclude/net/mac80211.h ieee80211_ctstoself_duration
+!Finclude/net/mac80211.h ieee80211_generic_frame_duration
+!Finclude/net/mac80211.h ieee80211_get_hdrlen_from_skb
+!Finclude/net/mac80211.h ieee80211_get_hdrlen
+!Finclude/net/mac80211.h ieee80211_wake_queue
+!Finclude/net/mac80211.h ieee80211_stop_queue
+!Finclude/net/mac80211.h ieee80211_start_queues
+!Finclude/net/mac80211.h ieee80211_stop_queues
+!Finclude/net/mac80211.h ieee80211_wake_queues
+      </sect1>
+    </chapter>
+
+    <chapter id="filters">
+      <title>Frame filtering</title>
+!Pinclude/net/mac80211.h Frame filtering
+!Finclude/net/mac80211.h ieee80211_filter_flags
+    </chapter>
+  </part>
+
+  <part id="advanced">
+    <title>Advanced driver interface</title>
+    <partintro>
+      <para>
+      	Information contained within this part of the book is
+      	of interest only for advanced interaction of mac80211
+      	with drivers to exploit more hardware capabilities and
+      	improve performance.
+      </para>
+    </partintro>
+
+    <chapter id="hardware-crypto-offload">
+      <title>Hardware crypto acceleration</title>
+!Pinclude/net/mac80211.h Hardware crypto acceleration
+<!-- intentionally multiple !F lines to get proper order -->
+!Finclude/net/mac80211.h set_key_cmd
+!Finclude/net/mac80211.h ieee80211_key_conf
+!Finclude/net/mac80211.h ieee80211_key_alg
+!Finclude/net/mac80211.h ieee80211_key_flags
+    </chapter>
+
+    <chapter id="qos">
+      <title>Multiple queues and QoS support</title>
+      <para>TBD</para>
+!Finclude/net/mac80211.h ieee80211_tx_queue_params
+!Finclude/net/mac80211.h ieee80211_tx_queue_stats_data
+!Finclude/net/mac80211.h ieee80211_tx_queue
+    </chapter>
+
+    <chapter id="AP">
+      <title>Access point mode support</title>
+      <para>TBD</para>
+      <para>Some parts of the if_conf should be discussed here instead</para>
+      <para>
+        Insert notes about VLAN interfaces with hw crypto here or
+        in the hw crypto chapter.
+      </para>
+!Finclude/net/mac80211.h ieee80211_get_buffered_bc
+!Finclude/net/mac80211.h ieee80211_beacon_get
+    </chapter>
+
+    <chapter id="multi-iface">
+      <title>Supporting multiple virtual interfaces</title>
+      <para>TBD</para>
+      <para>
+        Note: WDS with identical MAC address should almost always be OK
+      </para>
+      <para>
+        Insert notes about having multiple virtual interfaces with
+        different MAC addresses here, note which configurations are
+        supported by mac80211, add notes about supporting hw crypto
+        with it.
+      </para>
+    </chapter>
+
+    <chapter id="hardware-scan-offload">
+      <title>Hardware scan offload</title>
+      <para>TBD</para>
+!Finclude/net/mac80211.h ieee80211_scan_completed
+    </chapter>
+  </part>
+
+  <part id="rate-control">
+    <title>Rate control interface</title>
+    <partintro>
+      <para>TBD</para>
+      <para>
+      	This part of the book describes the rate control algorithm
+      	interface and how it relates to mac80211 and drivers.
+      </para>
+    </partintro>
+    <chapter id="dummy">
+      <title>dummy chapter</title>
+      <para>TBD</para>
+    </chapter>
+  </part>
+
+  <part id="internal">
+    <title>Internals</title>
+    <partintro>
+      <para>TBD</para>
+      <para>
+      	This part of the book describes mac80211 internals.
+      </para>
+    </partintro>
+
+    <chapter id="key-handling">
+      <title>Key handling</title>
+      <sect1>
+        <title>Key handling basics</title>
+!Pnet/mac80211/key.c Key handling basics
+      </sect1>
+      <sect1>
+        <title>MORE TBD</title>
+        <para>TBD</para>
+      </sect1>
+    </chapter>
+
+    <chapter id="rx-processing">
+      <title>Receive processing</title>
+      <para>TBD</para>
+    </chapter>
+
+    <chapter id="tx-processing">
+      <title>Transmit processing</title>
+      <para>TBD</para>
+    </chapter>
+
+    <chapter id="sta-info">
+      <title>Station info handling</title>
+      <sect1>
+        <title>Programming information</title>
+!Fnet/mac80211/sta_info.h sta_info
+!Fnet/mac80211/sta_info.h ieee80211_sta_info_flags
+      </sect1>
+      <sect1>
+        <title>STA information lifetime rules</title>
+!Pnet/mac80211/sta_info.c STA information lifetime rules
+      </sect1>
+    </chapter>
+
+    <chapter id="synchronisation">
+      <title>Synchronisation</title>
+      <para>TBD</para>
+      <para>Locking, lots of RCU</para>
+    </chapter>
+  </part>
+</book>
--- everything.orig/include/net/mac80211.h	2008-02-26 14:29:57.000000000 +0100
+++ everything/include/net/mac80211.h	2008-02-26 14:29:59.000000000 +0100
@@ -407,7 +407,6 @@ enum ieee80211_conf_flags {
  * @channel: the channel to tune to
  */
 struct ieee80211_conf {
-	unsigned int regulatory_domain;
 	int radio_enabled;
 
 	int beacon_int;
@@ -437,6 +436,7 @@ struct ieee80211_conf {
  * @IEEE80211_IF_TYPE_WDS: interface in WDS mode.
  * @IEEE80211_IF_TYPE_VLAN: VLAN interface bound to an AP, drivers
  *	will never see this type.
+ * @IEEE80211_IF_TYPE_MESH_POINT: 802.11s mesh point
  */
 enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_INVALID,
@@ -1096,8 +1096,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 /**
  * ieee80211_register_hw - Register hardware device
  *
- * You must call this function before any other functions
- * except ieee80211_register_hwmode.
+ * You must call this function before any other functions in
+ * mac80211. Note that before a hardware can be registered, you
+ * need to fill the contained wiphy's information.
  *
  * @hw: the device to register as returned by ieee80211_alloc_hw()
  */
--- everything.orig/net/mac80211/key.c	2008-02-26 14:29:57.000000000 +0100
+++ everything/net/mac80211/key.c	2008-02-26 14:29:59.000000000 +0100
@@ -20,8 +20,8 @@
 #include "aes_ccm.h"
 
 
-/*
- * Key handling basics
+/**
+ * DOC: Key handling basics
  *
  * Key handling in mac80211 is done based on per-interface (sub_if_data)
  * keys and per-station keys. Since each station belongs to an interface,
--- everything.orig/net/mac80211/sta_info.c	2008-02-26 14:29:58.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-26 14:29:59.000000000 +0100
@@ -31,10 +31,10 @@
  * for faster lookup and a list for iteration. They are managed using
  * RCU, i.e. access to the list and hash table is protected by RCU.
  *
- * Upon allocating a STA info structure with @sta_info_alloc() or
+ * Upon allocating a STA info structure with sta_info_alloc() or
  * mesh_plink_alloc(), the caller owns that structure. It must then either
- * destroy it using @sta_info_destroy() (which is pretty useless) or insert
- * it into the hash table using @sta_info_insert() which demotes the reference
+ * destroy it using sta_info_destroy() (which is pretty useless) or insert
+ * it into the hash table using sta_info_insert() which demotes the reference
  * from ownership to a regular RCU-protected reference; if the function
  * is called without protection by an RCU critical section the reference
  * is instantly invalidated.
@@ -42,19 +42,19 @@
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
  * that means it can be removed from the hash table but not be freed.
- * See the comment in @__sta_info_unlink() for more information.
+ * See the comment in __sta_info_unlink() for more information.
  *
  * In order to remove a STA info structure, the caller needs to first
- * unlink it (@sta_info_unlink()) from the list and hash tables and
+ * unlink it (sta_info_unlink()) from the list and hash tables and
  * then wait for an RCU synchronisation before it can be freed. Due to
  * the pinning and the possibility of multiple callers trying to remove
- * the same STA info at the same time, @sta_info_unlink() can clear the
+ * the same STA info at the same time, sta_info_unlink() can clear the
  * STA info pointer it is passed to indicate that the STA info is owned
  * by somebody else now.
  *
- * If @sta_info_unlink() did not clear the pointer then the caller owns
+ * If sta_info_unlink() did not clear the pointer then the caller owns
  * the STA info structure now and is responsible of destroying it with
- * a call to @sta_info_destroy(), not before RCU synchronisation, of
+ * a call to sta_info_destroy(), not before RCU synchronisation, of
  * course. Note that sta_info_destroy() must be protected by the RTNL.
  *
  * In all other cases, there is no concept of ownership on a STA entry,


