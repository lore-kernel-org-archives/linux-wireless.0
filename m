Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:35109 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786Ab0HYBSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 21:18:55 -0400
Message-ID: <4C746F74.70401@redfish-solutions.com>
Date: Tue, 24 Aug 2010 18:18:44 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>
Subject: Marshaling issues w/ compat-wireless-2010-08-19
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  I've got a stock Fedora Core 13 install (updated today) with the hostapd-0.6.10 rpm and hostapd-0.7.2 compiled from sources.  The NIC is a Ubiquiti SR71e (AR9280).

I installed compat-wireless-2010-08-19 after patching it with Johannes's fix posted earlier today.

I can confirm that hostapd and iw are no longer hitting the "Illegal nla->nla_type == 0" message when run.

But I'm seeing something else.

(1) "Unknown event 5" messages when starting up hostapd (line 95 below):
(2) Some highly unlikely values from the hostapd debugging messages when parsing out WEP authentication messages (line 507):

This is captured in http://pastebin.ca/1924659 :

authentication: STA=f8:1e:df:1e:c2:23 auth_alg=35510 auth_transaction=79 status_code=21688 wep=1
Unsupported authentication algorithm (35510)


I'm wondering if some messages that are passed up to user-space via netlink from the driver might have changed their schema, i.e. adding new fields in the middle of a structure or moving fields around within a structure.

Am I on the wrong track?  How to go about resolving this?

Thanks,

-Philip


