Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58225 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab0EMXPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 19:15:11 -0400
Received: by gyg13 with SMTP id 13so875222gyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 16:15:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BEC2318.5050701@create-net.org>
References: <4BEC2318.5050701@create-net.org>
Date: Fri, 14 May 2010 01:15:08 +0200
Message-ID: <AANLkTimnzAJd9Y02m8OBVLHphL5pbFw56M2LfB1L5oKz@mail.gmail.com>
Subject: Re: Strange ACK Behaviour with ath9k
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Roberto,

When I've seen this it has been caused by a mismatch between the
addresses in the injected frame and that configured in the hardware.
The transmitting radio doesn't understand it is the intended recipient
of the ack and continues retrying.

/Björn

On Thu, May 13, 2010 at 6:04 PM, Roberto Riggio
<roberto.riggio@create-net.org> wrote:
>
> Hi,
>
> I'm having a very strange behaviour between two sr71a (ath9k) cards
> operating in monitor mode. I'm using the following patch to specify
> the transmission rate frame by frame:
>
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/47441
>
>
> However if I try to send some traffic between the two nodes with both
> interfaces operating in monitor mode I can see from a third machine
> using wireshark that albeit the frame is sent and the corresponding
> ack generated, the originator seems to ignore the ACK and keepts
> retransmitting the frame. This is happening on both ends of the
> communication (i'm ping one node from the other).
>
> As a matter of fact i thought that ACK are handled directly by the
> firmware. Any hints?
>
> R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Venatech AB
Ideon Innovation
Ole Römers väg 12
SE-22370 LUND
Sweden

+46 (0) 46 286 86 20
info@venatech.se
http://www.venatech.se
