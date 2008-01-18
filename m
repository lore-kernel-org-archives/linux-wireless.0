Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61766 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759642AbYARQPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 11:15:12 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 05/12] iwlwifi: delay firmware loading from pci_probeto network interface open
Date: Fri, 18 Jan 2008 08:15:08 -0800
Message-ID: <D936D925018D154694D8A362EEB08920036F2884@orsmsx416.amr.corp.intel.com> (sfid-20080118_161519_763284_78978136)
In-Reply-To: <1200659720.5716.24.camel@johannes.berg>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com> <1200361585-31801-2-git-send-email-reinette.chatre@intel.com> <1200361585-31801-3-git-send-email-reinette.chatre@intel.com> <1200361585-31801-4-git-send-email-reinette.chatre@intel.com> <1200361585-31801-5-git-send-email-reinette.chatre@intel.com> <1200361585-31801-6-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022710_198103_7FE5555D) <1200659720.5716.24.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>, "Ian Schram" <ischram@telenet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, January 18, 2008 4:35 AM, Johannes Berg  wrote:

> Can you call *_init_geos() before registering the hw, i.e. before
> initialising the firmware? 

Yes we can. I am working on this. The _init_geos relies on information
from eeprom, not firmware, so we can do it during probe time.

Reinette
