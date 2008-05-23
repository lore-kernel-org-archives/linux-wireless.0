Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:6787 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYEWL0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 07:26:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATH] libertas: speeds up downloading of CF firmware
Date: Fri, 23 May 2008 13:26:31 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200805231018.26751.hs4233@mail.mn-solutions.de> <jeve15b72o.fsf@sykes.suse.de>
In-Reply-To: <jeve15b72o.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805231326.31570.hs4233@mail.mn-solutions.de> (sfid-20080523_132651_050633_84876869)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> That changes the return value.  Although it doesn't matter
> since all callers only check for < 0, it should perhaps be
> changed to return 0 here to avoid confusion.

You're right, the function returns now different things. But no 
caller cares for the different return value, therefore the code 
is correct as it is.

I actually used the return value to find out how many loops 
usually are needed to program, and found that I wait way to long 
in usleep() function.
