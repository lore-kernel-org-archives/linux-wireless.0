Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52421 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1DDGsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 02:48:47 -0400
Received: by ewy4 with SMTP id 4so1619405ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Apr 2011 23:48:45 -0700 (PDT)
Date: Mon, 4 Apr 2011 09:49:47 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] wl1251: Prepare for idle mode support
Message-Id: <20110404094947.5b178d78.jhnikula@gmail.com>
In-Reply-To: <87aag9srom.fsf@purkki.adurom.net>
References: <1301576643-29224-1-git-send-email-jhnikula@gmail.com>
	<87aag9srom.fsf@purkki.adurom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 01 Apr 2011 22:22:01 +0300
Kalle Valo <kvalo@adurom.com> wrote:

> > Then enum wl1251_cmd_ps_mod in cmd.h is renamed and moved to wl1251.h as it
> > is a state rather than chip level command.
> 
> But now you are moving a firmware interface value outside cmd.h. I was
> thinking that you would touch wl1251_cmd_ps_mod at all, instead just
> create a new enum wl1251_station_mode which will be used as the driver
> state variable.
> 
> That way it's clear which enum is for the firmware interface and which
> one is an internal variable.
> 
I agree, I was blind to see that the wl1251_cmd_ps_mode indeed sends the
value to chip... I'll send an update where the enum wl1251_cmd_ps_mod is
kept intact.

-- 
Jarkko
