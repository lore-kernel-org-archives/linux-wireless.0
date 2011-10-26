Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53460 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1JZQMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 12:12:00 -0400
Received: by ywm3 with SMTP id 3so1696672ywm.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 09:12:00 -0700 (PDT)
Message-ID: <4EA83160.4080405@lwfinger.net> (sfid-20111026_181205_739146_AA0AC6F7)
Date: Wed, 26 Oct 2011 11:12:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chiefdome <chiefdome@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T1  61652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org > <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org> <4E9CF13A.7060102@lwf inger.net> <loom.20111018T143746-420@post.gmane.org> <loom.201110 18T150303-359@post.gmane.org> <4E9D9953.3020601@lwfinger.net> <lo om.20111018T233233-298@post.gmane.org> <4E9E052F.8090705@lwfinger.net> <loom.20111019T101621-921@post.gmane.org> <4E9EBDD3.6060907@lwfinger.net> <loom.20111019T162518-352@post.gmane.org> <4E9F97B4.5010304@lwfinger.net> <loom.20111020T114336-286@post.gmane.org> <4EA023B2.5000402@lwfinger.net> <4EA82BFE.1070105@googlemail.com>
In-Reply-To: <4EA82BFE.1070105@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 10:49 AM, Chiefdome wrote:
> Is there a way to set the tx-power over 20dbm on the adapter?
> I thought it is able to do 2w. There is no way for me to get it over 20 dbm.
> When trying to to set the adapter with "iwconfig wlan1 set txpower 30" it answers
>
> Error for wireless request "Set Tx Power" (8B26) :
> SET failed on device wlan1 ; Invalid argument.
>
> I think there has to be done some work in the code but where do I start?
>
> Thanks for all replys.

The WEXT interface is deprecated. It is there as a convenience, but it will not 
be extended. To change the power setting, you need to use the iw utility. The 
specific commands are:

iw dev <devname> set txpower <auto|fixed|limit> [<tx power in mBm>]

or

iw phy <phyname> set txpower <auto|fixed|limit> [<tx power in mBm>]

The maximum power will be dependent on your regulatory domain setting.

Larry
