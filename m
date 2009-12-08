Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35328 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbZLHWXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:23:35 -0500
Received: by yxe17 with SMTP id 17so5361769yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 14:23:42 -0800 (PST)
Message-ID: <4B1ED1E9.2090103@lwfinger.net>
Date: Tue, 08 Dec 2009 16:23:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Michael Buesch <mb@bu3sch.de>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to
 suspend' warning
References: <685962.23975.qm@web23105.mail.ird.yahoo.com>
In-Reply-To: <685962.23975.qm@web23105.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2009 04:18 PM, Hin-Tak Leung wrote:
> 
> Sorry I haven't been paying too much attention due to other commitments... that sounds like race condition somewhere. Besides adding flag variables, would mutex help?

It is a race in the sense that mac80211 may queue a LED change during
the shut down process. So far, it seems that the slight change that I
posted to Herton's patch is going to work. It keeps the brightness
setting routine from queuing any more on/off sequences after the LED
has been removed.

Larry
