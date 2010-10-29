Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47073 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070Ab0J2Wbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 18:31:31 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PBxTo-0001YL-D0
	for linux-wireless@vger.kernel.org; Sat, 30 Oct 2010 00:31:24 +0200
Received: from CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com ([173.34.126.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 00:31:24 +0200
Received: from senada by CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 00:31:24 +0200
To: linux-wireless@vger.kernel.org
From: seno <senada@t-online.de>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Date: Fri, 29 Oct 2010 22:31:14 +0000 (UTC)
Message-ID: <loom.20101030T001241-932@post.gmane.org>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com> <4C7BC4D9.1010108@lwfinger.net> <20100830152841.GB2950@barata.holoscopio.com> <loom.20101026T200014-691@post.gmane.org> <4CC71CFF.8050004@lwfinger.net> <20101026185341.GA4608@barata.holoscopio.com> <20101028191305.2960c83b@gotham.conectiva> <loom.20101029T010426-834@post.gmane.org> <20101029135449.GB3768@barata.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thadeu Lima de Souza Cascardo <cascardo@...> writes:

> Perhaps, the problem is related to using compat-wireless. Have you tried
> using the module without the patch, using this same compat-wireless
> version in the same linux version you are using?

Cascardo, you were right :-) Your patch did not cause the problem.
I get those errors also with an unpatched compat-wireless-2010-10-25 driver.

With a patched compat-wireless-2.6.33.6 there occur no errors.

The router reports a better signal quality compared to the unpatched module, but 
I can not really recognize a better throughput - usually still max 1 mbit @ 10 
meters.

I noticed that the connection is fast for a short time after booting (10 mbit @ 
10 meters), but a few seconds after the download on speedtest.net started 
(meaning the network gets under load), speed drops to 1 mbit and never recovers 
to faster speed again; somehow like an "unrecoverable fallback mechanism"...?

