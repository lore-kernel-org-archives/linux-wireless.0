Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39973 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0CQA0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 20:26:16 -0400
Date: Tue, 16 Mar 2010 20:24:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] wireless: convert reg_regdb_search_lock to mutex
Message-ID: <20100317002416.GA2095@tuxdriver.com>
References: <4B9F86E9.2030702@gmail.com>
 <1268768940-5654-1-git-send-email-linville@tuxdriver.com>
 <20100316100337.GA1732@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20100316100337.GA1732@senthil-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 16, 2010 at 03:33:38PM +0530, Senthil Balasubramanian wrote:
> On Wed, Mar 17, 2010 at 01:19:00AM +0530, John W. Linville wrote:
> > Stanse discovered that kmalloc can be called with GFP_KERNEL while
> This commit log is confusing. It Should be "Stanse discovered kmalloc
> was called with GFP_KERNEL". Obviously kmalloc with GFP_KERNEL shouldn't
> be used while holding a spinlock.
> > holding this spinlock.  It can be a mutex instead.

Not half so confusing as your criticism... :-)

Are you objecting to "can be" instead of "was"?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
