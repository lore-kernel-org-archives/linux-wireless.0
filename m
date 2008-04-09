Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYDIIa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 04:30:28 -0400
Date: Wed, 9 Apr 2008 04:30:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jason Riedy <jason@acm.org>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Make IWLCORE a silent option not to confuse iwl3945
	users.
Message-ID: <20080409083025.GB17458@infradead.org> (sfid-20080409_093039_866175_25B54C55)
References: <874pakhist.fsf@sparse.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874pakhist.fsf@sparse.dyndns.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 01, 2008 at 11:28:34PM -0700, Jason Riedy wrote:
> The iwl3945 (currently?) does not use iwlcore.  Either the iwlcore
> documentation should change or the option should be silent.  This
> patch follows the latter route.  IWL4965 already SELECTs IWLCORE,
> so there should be no new problems.  Note that IWLWIFI_DEBUGFS and
> IWLCORE_RFKILL have no suboptions for 4965, so they are grouped
> together and given a description that includes "4965+" to indicate
> they're not for the 3945 adapters.

Just kill the option entirely and build the core module for both in
the makefile.

