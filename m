Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab0BCUqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 15:46:32 -0500
Subject: Re: [PATCH] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 12:43:44 -0800
Message-ID: <1265229824.21707.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-02 at 15:34 +0100, Stanislaw Gruszka wrote:
> Patch prevents call set_wep_key() with zero key length. That fix long
> standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
> "airo: clean up WEP key operations". Additionally print call trace when
> someone will try to use improper parameters, and remove key.len = 0
> assignment, because it is in not possible code path.

What problem/regression does this actually fix?  set_wep_key() should
never be called with zero-length key, so we should actually be returning
from that function instead of using WARN_ON() which would allow a
zero-length key to be set (which isn't really valid).

To disable a WEP key, the WEXT caller should be setting
IW_ENCODE_DISABLED in the flags, and *not* sending WEP keys.  Or if they
do for some reason send WEP keys, they need to use the key flag
IW_ENCODE_NOKEY to ensure they key is marked as "invalid" and ignored by
the driver.

Dan


