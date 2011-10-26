Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58947 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1JZVUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 17:20:19 -0400
Received: by ywm3 with SMTP id 3so1966561ywm.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 14:20:19 -0700 (PDT)
Message-ID: <4EA879A3.5040506@lwfinger.net> (sfid-20111026_232023_186757_407753F5)
Date: Wed, 26 Oct 2011 16:20:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chiefdome <chiefdome@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T1  61652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org > <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org> <4E9CF13A.7060102@lwf inger.net> <loom.20111018T143746-420@post.gmane.org> <loom.201110 18T150303-359@post.gmane.org> <4E9D9953.3020601@lwfinger.net> <lo om.20111018T233233-298@post.gmane.org> <4E9E052F.8090705@lwfinger.net> <loom.20111019T101621-921@post.gmane.org> <4E9EBDD3.6060907@lwfinger.net> <loom.20111019T162518-352@post.gmane.org> <4E9F97B4.5010304@lwfinger.net> <loom.20111020T114336-286@post.gmane.org> <4EA023B2.5000402@lwfinger.net> <4EA82BFE.1070105@googlemail.com> <4EA83160.4080405@lwfinger.net> <4EA861F5.4020200@googlemail.com>
In-Reply-To: <4EA861F5.4020200@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 02:39 PM, Chiefdome wrote:
> Did you tested the commands you posted to me? Anyway here they do nothing. I
> cant see any changes in iwconfig nor in in iw.
>
> iw reg get
> country 00:
> (2400 - 2494 @ 40), (N/A, 33)
> (4910 - 5895 @ 40), (N/A, 33)
>
> so after my regulatory domain I should be able to change the adapter settings.

No, I did not test them. If they don't work, then you need to debug cfg80211. 
These things are not a part of the driver. It only does what it is told.

You need to set a proper regulatory domain. Yours says "country 00", which is 
not right. Mine says

finger@larrylap:~> iw reg get
country US:
         (2402 - 2472 @ 40), (3, 27)
         (5170 - 5250 @ 40), (3, 17)
         (5250 - 5330 @ 40), (3, 20), DFS
         (5490 - 5600 @ 40), (3, 20), DFS
         (5650 - 5710 @ 40), (3, 20), DFS
         (5735 - 5835 @ 40), (3, 30)

and that 27 dBm exactly matches what iwconfig says.

Larry

