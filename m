Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:40647 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZBITRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 14:17:35 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1121595fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 11:17:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233685203-5093-1-git-send-email-reinette.chatre@intel.com>
References: <> <1233685203-5093-1-git-send-email-reinette.chatre@intel.com>
Date: Mon, 9 Feb 2009 20:17:33 +0100
Message-ID: <f6ca9fed0902091117k7326e51ag8469887cb1a99d53@mail.gmail.com> (sfid-20090209_201739_129865_4EC198BA)
Subject: Re: [ipw3945-devel] [PATCH v2.6.29] iwlwifi: save PCI state before
	suspend, restore after resume
From: drago01 <drago01@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 3, 2009 at 7:20 PM, Reinette Chatre
<reinette.chatre@intel.com> wrote:
> This is the right thing to do and fixes the following warning:
> [...]

With 2.6.29-rc4-git1 (which has this patch) I sometimes get:

iwl3945: Wait for START_ALIVE timeout after 2000ms.
iwl3945 0000:07:00.0: PCI INT A disabled

After resume with results into no working wireless until the module is reloaded.
I am not sure if this patch is the culprit (have not tried to revert
it), but that's the only change that might have caused this (with rc3
it was working fine, it just triggered the warning that this patch
supposed to solve).
