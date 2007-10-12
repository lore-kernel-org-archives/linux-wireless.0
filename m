Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36023 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbXJLOus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 10:50:48 -0400
Message-ID: <470F89C1.8030406@lwfinger.net> (sfid-20071012_155117_152339_7AC04EDE)
Date: Fri, 12 Oct 2007 09:50:41 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Marcus Better <marcus@better.se>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt2500pci 2.0.9 not working
References: <fdqhn4$qab$1@sea.gmane.org> <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com> <1192094159.4770.21.camel@johannes.berg> <200710112005.56101.IvDoorn@gmail.com> <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com> <fent23$9gc$1@sea.gmane.org>
In-Reply-To: <fent23$9gc$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcus Better wrote:
> Marcus Better wrote:
>> Kind-of works. I can connect but only at 1 Mb according to iwconfig.
> 
> Now I see that I got the same result even with driver version 2.0.7. I can
> change it with iwconfig though. Is this normal?

In mac80211, the association and authentication steps are always done at 1 Mb to maximize the
likelihood of that step succeeding. Once communication is established, the rate-setting mechanism in
rc80211_simple will adjust the rate to what it considers the highest value that works. You always
have the option of forcing a higher value with iwconfig at the risk of increasing the error rate.

Larry
