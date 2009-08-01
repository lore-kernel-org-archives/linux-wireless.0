Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:60758 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZHAUpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 16:45:35 -0400
Date: Sat, 1 Aug 2009 21:45:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
Message-ID: <20090801204534.GA23642@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com> <1249159133.3491.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249159133.3491.13.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 01, 2009 at 01:38:53PM -0700, Marcel Holtmann wrote:

> actually I would prefer if we name this key KEY_RFKILL and not put the
> policy of ALL into the kernel. Since we wanna get rid of rfkill-input.
> That needs to be done in userspace and by users policy. If they wanna
> map that key to ALL then that is fine. If they just wanna toggle WiFi,
> then that is also fine. If the wanna have to popup some UI, that is also
> reasonable.

My reasoning was that this conceptually maps to a key that controls all 
of the radios in the system - whether a single press actually kills all 
of them or not is kind of irrelevent (having the simple policy in 
rfkill-input works fine for this, but userspace will obviously want 
something more cunning). My concern with KEY_RFKILL is that it it's not 
obvious that it refers to a specific type of key - ones that purely 
control wifi should still be KEY_WLAN, for instance.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
