Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44736 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZFDN3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 09:29:31 -0400
Received: by bwz9 with SMTP id 9so733840bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2009 06:29:31 -0700 (PDT)
MIME-Version: 1.0
Reply-To: maxim@mox.ru
Date: Thu, 4 Jun 2009 17:29:31 +0400
Message-ID: <6097c490906040629o9c4f858pf1fa41932ed446fe@mail.gmail.com>
Subject: [RFC] ieee802154 configuration interface (iz)
From: Maxim Osipov <maxim.osipov@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm working currently on defining a command line configuration
interface for ieee802154 stack, keeping in mind further possible
extensions with ZigBee support, etc.

Current version below, however we have a heavy discussion regarding
design of the tool, and main questions are the following:

1. Is it better to have a single tool for configuration of all
protocols or one for ieee802154 (iz), one for ZigBee (zb) and so on?
2. Is it better to have a command defined (like "iz dev wpan0 poll")
and returning "Not implemented" or not defined at all?
3. Does it make sense to have a "phy" class? Currently we do not
provide any netlink interface to ieee802154 PHY, but I consider it may
be useful a) for testing b) for user-space implementation of certain
protocols.

Would appreciate comments and suggestions.

-----

iz [options] [class command]

Options:
 -d [--debug] - print netlink messages and other debug information
 -v [--version] - print version
 -h [--help] - print help

Classes:
 all - all known object classes
 phy - radio (master, PHY) interfaces
 dev - network interfaces (IEEE802.15.4 MAC, ZigBee, ...)

Common commands:
 list - list all interfaces of class(es)
 event - monitor events of class(es) from the kernel
 add <iface> - add interface
 del <iface> - delete interface

IEEE 802.15.4 PHY specific commands:
 cca - perform clear channel assignment procedure
 ed - perform energy detect procedure
 set-trx-state - change transmitter state
 get - get PIB value
 set - set PIB value

 Events are: CCA-CONF, ED-CONF, SET-TRX-STATE-CONF, GET-CONF, SET-CONF

IEEE 802.15.4 MAC specific commands:
 associate - associate with a network
 disassociate - disassociate from a network
 gts - configure guaranteed time slots
 orphan-response - react to orphan indication
 reset - reset
 rx-enable - enable receiver
 scan - perform scan
 start - start node
 sync - synchronize with a beacon
 poll - poll for data
 get - get MIB value
 set - set MIB value

 Events are: ASSOCIATE-IND, ASSOCIATE-CONF, DISASSOCIATE-IND,
DISASSOCIATE-CONF, BEACON-IND...

ZigBee specific commands:
 net-discovery - discover networks operating within device visibility
 net-formation - start a new network as a coordinator
 permit-join - start accepting devices to a network (router or coordinator)
 start-router - start router activities (router)
 ed-scan - request energy detection scan
 join - join/rejoin a network or change operating channel
 direct-join - directly join another device to a network
 leave - leave a network
 reset - perform reset operation
 sync - synchronize (with coordinator or router) or check for pending data
 route-discovery - initiate route discovery
 get - get NIB or AIB value
 set - set NIB or AIB value

 Events are: NET-DISCOVERY-CONF, NET-FORMATION-CONF,
PERMIT-JOINING-CONF, START-ROUTER-CONF, ED-SCAN-CONF, JOIN-IND,
JOIN-CONF...

Kind regards,
Maxim
