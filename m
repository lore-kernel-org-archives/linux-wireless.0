Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62232 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2ARRQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 12:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <1326874421-4654-1-git-send-email-coelho@ti.com>
References: <1326874421-4654-1-git-send-email-coelho@ti.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 18 Jan 2012 09:15:46 -0800
Message-ID: <CAB=NE6WFFPgQkBvn8uShMVG1+SExUFXfa9dW2jLGad62Sc5dOA@mail.gmail.com> (sfid-20120118_181617_847944_793EBB03)
Subject: Re: [PATCH] compat-wireless: check if modprobe exists before using it
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	wlist@ti.com, idor@ti.com, assaf@ti.com, gil.barak@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 18, 2012 at 12:13 AM, Luciano Coelho <coelho@ti.com> wrote:
> If you're cross-compiling compat-wireless on a different host, you
> can't reliably use modprobe.  The host system may not even have
> modprobe, so it doesn't make sense to run modprobe, unless you're
> installing the modules on the target machine.
>
> The modprobe command was being used unconditionally to set the MADWIFI
> and OLD_IWL variables.  This commit adds a check to see whether
> modprobe exists before trying to use.  It also adds a dependency on
> the modprobe commands to all recipes that rely on it, so we fail more
> gracefully if modprobe doesn't exist in the system.
>
> Reported by: William List <wlist@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Good point, I've propagated this into the linux-3.2.y and linux-3.1.y
branches of compat-wireless as well so that if a new release is made
the fixes go along with it.

  Luis
