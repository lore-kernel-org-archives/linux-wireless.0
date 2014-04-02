Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61975 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbaDBCeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 22:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <1423990.vA4A9XhDx1@tijs>
References: <1423990.vA4A9XhDx1@tijs>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 1 Apr 2014 19:33:57 -0700
Message-ID: <CAB=NE6UeCQD9WmbyZH_asJLHS_tOGHvfF49XBqfSb-_WOZaY0w@mail.gmail.com> (sfid-20140402_043423_480353_B39B5774)
Subject: Re: [wireless] [b43] [brcmsmac] [3.3.8]: backport bcma_core_pci_up/down
 from 3.12
To: tvb@able.be
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 14, 2014 at 12:51 PM, Tijs Van Buggenhout <tvb@able.be> wrote:
>
> +       bcma_core_pci_extend_L1timer(pc, true);

This is is a static routine defined elsewhere in the kernel and will
break compilation. This patch breaks compilation, please try reading
drivers/bcma/driver_pci.c and look for a better way to backport this.
Also please try to test patches with 'ckmake --allyesconfig' for
patches like this after first having used backports-update-manager to
update your system.

  Luis
