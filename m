Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55794 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1FIPZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 11:25:20 -0400
Received: by pwi15 with SMTP id 15so790441pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 08:25:19 -0700 (PDT)
Date: Thu, 9 Jun 2011 18:24:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, vasanth@atheros.com
Subject: Re: [PATCH 5/5] ath6kl: fix crash when interface is closed but scan
 is ongoing
Message-ID: <20110609152453.GH4069@shale.localdomain> (sfid-20110609_172524_353786_4C2C8D1C)
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
 <20110608115501.32208.82264.stgit@localhost6.localdomain6>
 <20110608200332.GC4069@shale.localdomain>
 <20110608201458.GD4069@shale.localdomain>
 <87sjrj6svb.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87sjrj6svb.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 09, 2011 at 04:23:36PM +0300, Kalle Valo wrote:
> I only combined the pending ath6kl patches, I did not edit them.
> Vasanth sent patch 4 few days earlier and that's why you see the
> change here. But if greg wants, I can drop patch 4 and resend the
> series.

Part of the problem is that patch doesn't add the check for NULL
consistently throughout the function.  There is a place where a NULL
deref could still be triggered later on.  Let's just drop it instead
of fixing it.

regards,
dan carpenter
