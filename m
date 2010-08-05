Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mundo.umh.es ([193.147.147.4]:58879 "EHLO mundo.umh.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab0HELzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 07:55:08 -0400
Received: from uwicorejohn (unknown [10.1.60.23])
	by mundo.umh.es (Postfix) with ESMTP id 0C03628DBA5
	for <linux-wireless@vger.kernel.org>; Thu,  5 Aug 2010 13:55:07 +0200 (CEST)
From: =?iso-8859-1?Q?J=F3natan_Mu=F1oz?= <jmunoz@umh.es>
To: <linux-wireless@vger.kernel.org>
Subject: [ath9k]: Beaconing process in ad-hoc mode
Date: Thu, 5 Aug 2010 13:55:05 +0200
Message-ID: <002c01cb3495$0ff49610$2fddc230$@es>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,

I am working in a project where I need to modified the currently beaconing
system for adhoc mode in ath9k, what I want to achieve is that each station
in an adhoc network send periodically a beacon. As I know, when a station in
the network receives a beacon before sending its own beacon, cancels the
transmission, updates its hw tsf based on the received beacon and waits for
a chance to send the beacon during next TBTT.

For my goal, I think that I should comment the part where the transmission
of the beacon is cancelled. In this way, each station will send a beacon
each 100TU (~100 ms). I know that this mean a increased traffic load on the
network, but it is so much important for the project to obtain a beacon for
each station each 100ms.

Right now, I am looking at the source code of ath9k, I am trying to modify
the file beacon.c, but I don’t find the way to get my purpose. Could anyone
help me to find the right place at the code that I have to modify? I am a
bit lost and any help would be greatly appreciated.

Thanks in advance.

PD: Please excuse my poor English

John



------------------------------------------
Jónatan Muñoz
Email: jmunoz@umh.es
Ubiquitous Wireless Communications Research Laboratory 
Uwicore, http://www.uwicore.umh.es 
Signal Theory and Communications Division 
University Miguel Hernández of Elche 

Avenida de la Universidad s/n 
Edificio Quorum V P2 012
03202, Elche (Alicante) 
Spain 
Tel: +34 96522 2031 /+34 669256708
Fax: +34 96665 8903 
------------------------------------------



