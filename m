Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50062 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYHGIHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 04:07:18 -0400
Date: Thu, 7 Aug 2008 11:06:25 +0300
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Dave <kilroyd@googlemail.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
Message-ID: <20080807080625.GF18172@jm.kir.nu> (sfid-20080807_100725_953373_EF5DEE6B)
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <1217822232.10989.13.camel@dv> <48978C25.601@gmail.com> <1217892514.17793.39.camel@localhost.localdomain> <1217983050.19480.41.camel@dv> <4899EE69.6050205@gmail.com> <1218056481.12240.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1218056481.12240.9.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 06, 2008 at 05:01:21PM -0400, Dan Williams wrote:

> That's probably OK.  The driver doesn't say it supports WPA2+TKIP, so
> you're in the clear here.  Either the supplicant has to be fixed to
> respect driver capabilities, or the user has to know.  I vote for fixing
> the supplicant.

I have been postponing this since most drivers did not use to report
their capabilities correctly. Anyway, if the driver is indeed reporting
its capabilities, I would agree that wpa_supplicant should follow what
is reported. I think that there's already code for reading the
capabilities, but the code that acts on them (i.e., rejects some options
in scan results) has not yet been written. I need to make sure that all
driver wrappers default to enabling everything if the driver does not
report capabilities, so that we can start filtering available options
without breaking something that is working in the current version.

-- 
Jouni Malinen                                            PGP id EFC895FA
