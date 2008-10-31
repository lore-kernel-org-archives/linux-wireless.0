Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:52397 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYJaSDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 14:03:19 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/6] rtl8187: Reduce delays to reduce startup time
Date: Fri, 31 Oct 2008 16:03:28 -0200
Cc: John Linville <linville@tuxdriver.com>,
	htl10@users.sourceforge.net, Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net> <490B3798.40206@lwfinger.net>
In-Reply-To: <490B3798.40206@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810311603.29317.herton@mandriva.com.br> (sfid-20081031_190324_619410_1D0A05A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 October 2008 14:51:36 Larry Finger wrote:
> The current version of the rtl8187 driver contains a large number of msleep()
> commands that cause initialization to take a long time. This series of patches
> include revisions that were found by looking at the latest version of the
> vendor's driver (rtl8187B_linux_26.1036.0708.2008), and others that were found
> to be OK with testing.
> 
> To keep each of the patches relatively small, these changes are split into 6
> parts. The changes in them are as follows:
> 
> 1. Remove all delays of greater than 1 sec.
> 2. Remove the msleep(1) that immediately follow calls to rtl8225_write_phy_ofdm().
> 3. Remove the msleep(1) that immediately follow calls to rtl8225_write_phy_cck().
> 4. Remove the msleep(1) that immediately follow calls to rtl8225_write().
> 5. Remove the nsleep() calls from rtl8187_write_phy(), rtl8225_write_bitbang(),
> and rtl8225_write_8051().
> 6. Remove the msleep(10) that preceeds a channel change.
> 
> Before these changes, routine rtl8187b_init_hw() took 15.82 sec to execute. It
> now takes 3.76 sec.

I tested here the 6 patches, and didn't found problems with them (testing with
two 8187 models, one an old 8187L and other an 8187B).

Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

--
[]'s
Herton
