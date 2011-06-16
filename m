Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1FPKVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 06:21:34 -0400
Date: Thu, 16 Jun 2011 12:22:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: use BUG_ON and return -EINVAL if
 rate_lowest_index() fails
Message-ID: <20110616102224.GB2178@redhat.com> (sfid-20110616_122142_519916_76BF0170)
References: <20110615220252.1918.73638.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110615220252.1918.73638.stgit@mj.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel

On Wed, Jun 15, 2011 at 06:02:52PM -0400, Pavel Roskin wrote:
> WARN_ON is not enough, as we cannot return a valid index, and the
> callers will use whatever we return, causing a cascade of oopses and
> eventually a panic.

We have fedora bug (https://bugzilla.redhat.com/show_bug.cgi?id=702627) 
where only that warning is generated, and system works further (at least
bug reporter did not mention about it's hang). When moving to BUG(),
system from user perspective will simply hang, what is much worse.
I think, we should rather fix callers to be prepared and recover itself
when rate_lowest_index fail. Of course fixing real bug(s) that cause
rate index is not found would be best.
 
Stanislaw
