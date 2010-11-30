Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58050 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0K3Aoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 19:44:44 -0500
Received: by iwn5 with SMTP id 5so784185iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 16:44:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291038135-20672-1-git-send-email-shahar_levi@ti.com>
References: <1291038135-20672-1-git-send-email-shahar_levi@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Nov 2010 16:44:23 -0800
Message-ID: <AANLkTikUOfQbk-TEE2=EejXOTr_t-LXvTim-Sc1OVwKG@mail.gmail.com>
Subject: Re: [PATCH v4 ] wl12xx: BA Initiator support
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shahar,

On Mon, Nov 29, 2010 at 5:42 AM, Shahar Levi <shahar_levi@ti.com> wrote:
...
> -#define WL1271_FW_NAME "wl1271-fw.bin"
> +#define WL1271_FW_NAME "wl1271-fw-2.bin"

Changing the firmware's major version involves usability and
maintainability pain to the entire wl12xx community, especially if
done repeatedly, and therefore should be generally avoided.

When the firmware API changes, and the old driver can't work with it
anymore, then you have no choice but changing the name.

But if it's just a small API extension enabling new driver
functionality, you should really avoid bumping the firmware version,
and instead try to dynamically detect it from the driver and act
appropriately.

Please explain what has exactly been changed in the firmware and let's
try to find a clean solution.

Thanks,
Ohad.
