Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58223 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZC0GS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 02:18:29 -0400
Received: by bwz17 with SMTP id 17so848339bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 23:18:26 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Fri, 27 Mar 2009 07:18:17 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Wey-Yi Guy" <wey-yi.w.guy@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> <1238087650-26993-2-git-send-email-reinette.chatre@intel.com> <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903270718.18593.helmut.schaa@gmail.com> (sfid-20090327_071833_495524_1C9E02C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

Am Donnerstag, 26. M=E4rz 2009 schrieb Reinette Chatre:
> Remove STATUS_ALIVE checking when HW RF KILL disabled, the bit get
> clear in __iwl_down() function; the additional checking will fail and
> cause RF can not be turn back on.

Maybe just checking for is_open instead of STATUS_ALIVE will fix the is=
sue
too? I only had a quick look but it looks possible. AFAICS is_open indi=
cates
if the interface was taken up by mac80211. So if the interface is up bu=
t
STATUS_ALIVE is not set we want to restart the adapter after unkilling =
but
if the interface is still down (is_open=3D=3D0) we do not want to resta=
rt the
adapter. Furthermore, is_open is also set in case the interface was tak=
en
up but wireless was rfkilled.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
