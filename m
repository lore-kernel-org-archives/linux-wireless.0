Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2287 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2HBOBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 10:01:03 -0400
Message-ID: <501A880A.6030000@broadcom.com> (sfid-20120802_160107_286733_3F22BF75)
Date: Thu, 2 Aug 2012 16:00:42 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Josh Boyer" <jwboyer@redhat.com>
cc: "Seth Forshee" <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/2] Fix lockdep warning in brcmsmac
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
 <20120802002353.GD1785@zod.bos.redhat.com>
 <20120802015320.GA25933@thinkpad-t410>
 <20120802120230.GE1785@zod.bos.redhat.com>
 <20120802125102.GF1785@zod.bos.redhat.com>
 <501A83AF.9060706@broadcom.com>
 <20120802134512.GG1785@zod.bos.redhat.com>
In-Reply-To: <20120802134512.GG1785@zod.bos.redhat.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2012 03:45 PM, Josh Boyer wrote:
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=m
> CONFIG_BCMA_BLOCKIO=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> # CONFIG_BCMA_DEBUG is not set

As you indicated not seeing anything on the bcma bus (in kernel log, you
mean?) I was wondering about BCMA_HOST_PCI flag, but that looks fine.
Not sure why you have BCMA_DRIVER_GMAC_CMN enabled. Grabbing straws.

I actually had a similar behaviour and noticed a PCI bridge port was
missing. Do you see that also with lspci?

Gr. AvS

