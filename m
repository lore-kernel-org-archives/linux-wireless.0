Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbbESQpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 12:45:36 -0400
Date: Tue, 19 May 2015 18:45:33 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: ming.lei@canonical.com, gregkh@linuxfoundation.org, tiwai@suse.de
Cc: rusty@rustcorp.com.au, torvalds@linux-foundation.org,
	dhowells@redhat.com, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCH v3 0/4] firmware: few fixes for name uses
Message-ID: <20150519164533.GF23057@wotan.suse.de> (sfid-20150519_184551_892094_D481F62A)
References: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2015 at 02:49:39PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This v3 changes patch 1 to just return -ENOMEM and remove the
> unlikely() optimization. It also drops the early truncation
> checks.
> 
> Luis R. Rodriguez (4):
>   firmware: fix __getname() missing failure check
>   firmware: check for file truncation on direct firmware loading
>   firmware: fix possible use after free on name on asynchronous request
>   firmware: use const for remaining firmware names
> 
>  drivers/base/firmware_class.c | 61 +++++++++++++++++++++++++++++++------------
>  1 file changed, 45 insertions(+), 16 deletions(-)

Ming, a review would be much appreciated. I also have a few other changes coming
later, so should these go through Greg or Takashi first ? If its of any help
I'm happy to take on co-maintenance on this module given that I am lookng
to do quite a bit of surgery on the APIs later.

 Luis
