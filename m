Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10009 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbYFEMCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 08:02:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] libertas: check for old, unsupported hardware
Date: Thu, 5 Jun 2008 14:02:39 +0200
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200806051308.35863.hs4233@mail.mn-solutions.de> <1212666420.25730.4.camel@localhost.localdomain>
In-Reply-To: <1212666420.25730.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806051402.39736.hs4233@mail.mn-solutions.de> (sfid-20080605_140251_465637_B762E447)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got this piece of code from the 5.0.16 GPL driver, but 
implemented it differently. I mainly put it in to find out if 
YOU have such an old silicon. When people yell "my card isn't 
supported, I get this kernel error" we can still add the 
necessary support.

I don't want to add the support right now because I don't have 
this old hardware and don't know anyone with it. So no-one could 
test this.


The 5.0.16 source mentions two things needed for this old 
hardware:

* doing read-modify-write instead of just setting bits, this
  applies to IF_CS_HOST_STATUS and IF_CS_HOST_INT_CAUSE
* and an interrupt workaround

The interrupt workaround isn't in the 5.0.16 source.
