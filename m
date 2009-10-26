Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:27456 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZJZNbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:31:15 -0400
From: Holger Schurig <h.schurig@mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Subject: RECAP: plan for cfg80211 & mesh
Date: Mon, 26 Oct 2009 14:30:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910261430.44098.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After some talk on IRC I have the following plan:

* all WEXT code for the normal STA code goes into
  assoc.c, wext.c and scan.c. Therefore, all my
  patches not marked as RFC should be reviewed and
  go into the kernel.

* There will be no CONFIG_LIBERTAS_WEXT or
  CONFIG_LIBERTAS_CFG80211 command line option, so we
  have one "flip-day", where we go from WEXT based
  confuguration to CFG80211-based configuration (note
  that cfg80211 allowes WEXT-based tools via compat-wext.c)

* for Libertas' mesh, we'll get an CONFIG_LIBERTAS_MESH
  config.

* Liberas' mesh code also depend on WIRELESS_WEXT, it needs
  4 WEXT ioctls: get ssid, set ssid, get mode and set channel.
  For the beginning, libertas+cfg80211 will behave similar to
  libertas+wext. That means: at module probing + initialization
  time, it probes the firmware for mesh. It will the create a
  (cfg80211 controlled) interface for STA, and if firmware
  supports MESH, it creates an (wext controlled) mshX device.

* I plan to code the mesh code, as it seems now quite simple.
  Testing must be done by third-parties.

  I want to move all mesh related code into one or two files,
  probably persistcfg+ethtool+mesh-stuff from main.c into
  mesh.h/mesh.c. Or rename persistcfg.c to mesh.c, something
  around this lines. This makes CONFIG_LIBERTAS_MESH less
  intrusive.

* That means we have a bunch of WEXT cleanup patches, that
  move things around in order to isolate WEXT related stuff
  into some files. And another bunch of MESH cleanup
  patches, that isolate MESH in some files.

  And then, at "flag day" there will come a patch that
  adds the full cfg80211 support, the CONFIG_LIBERTAS_MESH
  Kconfig and removes the WEXT-code, now isolated in
  scan.c, assoc.c and wext.c.

  At some later time, if people are still interested in
  MESH (OLPC people should document by maintaining it)
  we can fully get rid of MESH-related WEXT code by
  converting it to CFG80211, too. Otherwise, we might
  rip out MESH, which will also be easier because of
  the isolation.

* It's not clear yet if the first libertas+cfg80211
  will support adhoc, monitor reception and monitor
  packet injection. All of this might come on the
  "flag day" --- or later. Full station mode will
  come, sans some bugs :-)


Dan, I hope this recap is what we talked about. If not, please 
correct me. All other parties, please comment.

-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
