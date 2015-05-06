Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbbEFRzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 13:55:44 -0400
Date: Wed, 6 May 2015 19:55:41 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 00/12] kernel/firmware/wireless: firmware digital
 signature checks
Message-ID: <20150506175541.GN5622@wotan.suse.de> (sfid-20150506_195609_251725_D61141A3)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 05, 2015 at 05:44:18PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
>   * first set: [1-4] few fixes and core changes in order to consider digital
>     firmware signature support. Please consider these for integration. Patch
>     2 generalizes module signing as system data signing and can very likely
>     just be ignored unles the second set seems more reasonable to start
>     considering. One of these goes as a stable fix.

Rusty, based on feedback only one patch is relevant for upstream consideration
then on your end:

  1  - kernel/params.c: export param_ops_bool_enable_only                                                                                                                       

Ming, as for firmware_class, this patch should be reviewed and
considered for upstream consideration:

  4  - firmware: fix possible use after free on name on asynchronous request 

The patches are orthogonal to each other so they can be considered
separately, and can go in through separate trees.

  Luis
