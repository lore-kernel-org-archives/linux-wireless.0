Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:33181 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab0BCVbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 16:31:12 -0500
To: Dan Williams <dcbw@redhat.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Subject: Re: [PATCH] airo: fix setting zero length WEP key 
In-reply-to: dcbw's message of Wed, 03 Feb 2010 12:43:44 -0800.
             <1265229824.21707.10.camel@localhost.localdomain>
Date: Wed, 03 Feb 2010 16:31:09 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100203213109.B2D802B0054@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| > Patch prevents call set_wep_key() with zero key
| > length. That fix long standing regression since commit
| > c0380693520b1a1e4f756799a0edc379378b462a "airo: clean up WEP key
| > operations". [...]
|
| What problem/regression does this actually fix? [...]

 That mentioned commit broke wireless on a Thinkpad T42 (running Fedora
11); from that commit onwards, the wireless system appeared to see no
networks. The patch makes things work again.

 More details are in the Fedora bugzilla:
	https://bugzilla.redhat.com/show_bug.cgi?id=522530

	- cks
