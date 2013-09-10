Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:54379 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab3IJGee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 02:34:34 -0400
Message-ID: <1378794898.4799.37.camel@porter.coelho.fi> (sfid-20130910_083437_293724_3650DEB9)
Subject: Re: [PATCH 03/12] wlcore: disable elp sleep while in plt mode
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Sep 2013 09:34:58 +0300
In-Reply-To: <1378218848-7853-3-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-3-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 17:33 +0300, Eliad Peller wrote:
> From: Yair Shapira <yair.shapira@ti.com>
> 
> We now disable elp sleep during plt mode to allow normal operation of
> plt tools such as calibrator.
> 
> Having elp_sleep enabled during plt mode is actually not required and
> in fact it disrupt plt operations such as rx statistics etc.
> 
> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I also had a comment internally about this one.  Why do we need this?
AFAICT this would never happen in real life, since the firmware is not
even loaded at this point.  Is there any real life situation where we
try to go into ELP while in PLT mode?

--
Luca.

