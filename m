Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36646 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1JZVbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 17:31:00 -0400
Received: by gyb13 with SMTP id 13so1966529gyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 14:31:00 -0700 (PDT)
Message-ID: <4EA87C25.1070403@lwfinger.net> (sfid-20111026_233105_390661_CB96D65B)
Date: Wed, 26 Oct 2011 16:31:17 -0500
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
>
> Did you tested the commands you posted to me? Anyway here they do nothing. I
> cant see any changes in iwconfig nor in in iw.
>
> iw reg get
> country 00:
> (2400 - 2494 @ 40), (N/A, 33)
> (4910 - 5895 @ 40), (N/A, 33)
>
> so after my regulatory domain I should be able to change the adapter settings.

I now have tested. My device is limited to 27 dBm, thus the limit in the txpower 
command is 2700, but one can reduce the power.

finger@larrylap:~/linux-2.6> iwconfig wlan25
wlan25    IEEE 802.11bg  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=54 Mb/s   Tx-Power=27 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off
           Link Quality=66/70  Signal level=-44 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:93  Invalid misc:270   Missed beacon:0

finger@larrylap:~/linux-2.6> sudo iw dev wlan25 set txpower limit 2200
finger@larrylap:~/linux-2.6> iwconfig wlan25
wlan25    IEEE 802.11bg  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=54 Mb/s   Tx-Power=22 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off
           Link Quality=68/70  Signal level=-42 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:93  Invalid misc:270   Missed beacon:0

With your regulatory info, you should be able to get 3300, unless the rtl8192cu 
firmware has a limit to keep you from destroying the chip.

Perhaps you should ask Alfa about this issue.

Larry
