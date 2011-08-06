Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41529 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab1HFCu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 22:50:56 -0400
Date: Fri, 5 Aug 2011 22:50:51 -0400
From: Pavel Roskin <proski@gnu.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	emmanuel.grumbach@intel.com,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv
 pointer
Message-ID: <20110805225051.435fe1b0@mj> (sfid-20110806_045105_452024_548F5F50)
In-Reply-To: <1312499702.15170.17.camel@wwguy-huron>
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
	<CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
	<CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
	<CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com>
	<1312499702.15170.17.camel@wwguy-huron>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 04 Aug 2011 16:15:02 -0700
"Guy, Wey-Yi" <wey-yi.w.guy@intel.com> wrote:

> Could you look into this, we need to fix it for 3.1

The backtrace looked interesting to me, so I checked the code.

It looks like iwl_pci_down() badly needs to be merged with
iwl_pci_remove().  iwl_pci_down() is only called from iwl_pci_remove(),
and is struggles badly to get the data that iwl_pci_remove() already
has.  That may fix everything.  Unfortunately, I have no hardware to
test it.

pci_bus->pci_dev that iwl_pci_down() passes to pci_disable_msi() should
be the same as pdev in iwl_pci_remove().  And pdev should be valid
throughout the function.

Also, the use of the void pointer in iwl_pci_remove() seems
unjustified.  Specific pointers are always better.

-- 
Regards,
Pavel Roskin
