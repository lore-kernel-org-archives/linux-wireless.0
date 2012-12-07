Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:38336 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030505Ab2LGNxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 08:53:02 -0500
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp02.msg.oleane.net (MTA) with ESMTP id qB7Dr0s1029864
	for <linux-wireless@vger.kernel.org>; Fri, 7 Dec 2012 14:53:00 +0100
Subject: [RFC] ATH9K: infinite loop in Tasklet
Date: Fri, 7 Dec 2012 14:52:59 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A319014120A1@sbs2003.acksys.local> (sfid-20121207_145307_031088_5127601A)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

                Dear mailling list, 
                
                I think there is a possible infinite loop in ATH9K tasklet, and this loop block the linux kernel.

     	 In my test based on freescale MPC8315 cpu, the Wireless card is bridged to Ethernet driver (Gianfar). When I receive data from Wifi (iperf -c xx -b50M) to Ethernet, the Gianfar NAPI poll function is never called because the ath_rx_tasklet always loops.

                In the ath_rx_tasklet(...), the "while" loops until ath_get_next_rx_buf() or ath_edma_get_next_rx_buf returns a buffer. 

                If these functions always  return a buffer, this tasklet always runs. While this tasklet runs, all other tasklets are blocked. 
      To fix it I applied this patch:
      
      --- recv.c             2012-12-07 14:30:26.000000000 +0100
      +++ recv.c.new                2012-12-07 14:30:05.364591961 +0100
      @@ -1067,6 +1067,7 @@
                     u64 tsf = 0;
                     u32 tsf_lower = 0;
                     unsigned long flags;
      +             int count = 150;
      
                      if (edma)
                                    dma_type = DMA_BIDIRECTIONAL;
      @@ -1085,6 +1086,10 @@
                                    if (test_bit(SC_OP_RXFLUSH, &sc->sc_flags) && (flush == 0))
                                                    break;
      
      +                             if(count <= 0)
      +                                            break;
      +
      +                             count --;
                                    memset(&rs, 0, sizeof(rs));
                                    if (edma)
                                                    bf = ath_edma_get_next_rx_buf(sc, &rs, qtype);
      
      I think this solution is not correct, because the tasklet is not rescheduled and we always have data in Rx buffer. 
      
                Have you any suggestion to fix this issue correctly?

                Thanks for your help.

                Best regards.

