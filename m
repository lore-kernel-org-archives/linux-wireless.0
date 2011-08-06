Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30925 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab1HFSRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 14:17:13 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Pavel Roskin <proski@gnu.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: Daniel Halperin <dhalperi@cs.washington.edu>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 6 Aug 2011 11:17:05 -0700
Subject: RE: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv
 pointer
Message-ID: <E9954878DD1FB34FAE5187FB88C58A350199604D92@orsmsx506.amr.corp.intel.com> (sfid-20110806_201716_588650_7B9A3C46)
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
	<CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
	<CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
	<CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com>
	<1312499702.15170.17.camel@wwguy-huron> <20110805225051.435fe1b0@mj>
In-Reply-To: <20110805225051.435fe1b0@mj>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel,

Could you help since I don't have the system for next few weeks.

Thanks
Wey

-----Original Message-----
From: Pavel Roskin [mailto:proski@gnu.org]
Sent: Saturday, August 06, 2011 5:51 AM
To: Guy, Wey-Yi W
Cc: Daniel Halperin; Grumbach, Emmanuel; linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer

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
