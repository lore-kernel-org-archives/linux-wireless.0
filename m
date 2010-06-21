Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:34748 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753782Ab0FUHvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 03:51:50 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0518656707
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 16:51:48 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Jaroslav Fojtik" <jafojtik@seznam.cz>
Subject: Re: ATH5k - Signal measurement reports wrong values
Date: Mon, 21 Jun 2010 16:50:50 +0900
Cc: linux-wireless@vger.kernel.org
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz> <201006211026.48484.br1@einfach.org> <4C1F135A.26516.F45AB@jafojtik.seznam.cz>
In-Reply-To: <4C1F135A.26516.F45AB@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006211650.50766.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon June 21 2010 16:23:06 Jaroslav Fojtik wrote:
> Dear Bruno,
> 
> > hi jara!
> > 
> > are you sure it has to do with the upgrade from
> > compat-wireless-2010-06-13 to compat-wireless-2010-06-18? i don't see
> > any relevant differences in the code between these two versions...
> 
>   Sorry, it might be compat-wireless-2010-05-30.

that would make more sense. there are changes in noise floor calibration and 
in antenna diversity setup between these two (2010-05-30 and 2010-06-18). 
either one may be the reason...

> I have tested only 3 versions.
> 
> Anyway, I have observed "false" signal drop even for client stations.
> 
> You could see that purple line als dropped from -61 to -71 without any
> reason: http://78.108.103.11:11080/cgi-bin/klienti_year.cgi
> 
> > it might be interresting to see what results you get from noise
> > calibration. you can enable calibration debugging with "echo calib >
> > /sys/kernel/debug/ath5k/phy0/debug"
> 
> The directory /sys/kernel/debug is empty.
> It looks that I have to recompile kernel. Or do you know any option to
> pass to kernel to allow this feature?

maybe you need to:
  mount -t debugfs debugfs /sys/kernel/debug
?

also you need to compile ath5k with debugging enabled.

can you tell us which chipset you are using (output of dmesg |grep 
"ath5.*chip")?

also it would be interesting to know how you generate your graphs?

bruno


