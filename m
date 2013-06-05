Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:54991 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab3FEUVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:21:44 -0400
Received: by mail-we0-f178.google.com with SMTP id u53so1667343wes.23
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:21:43 -0700 (PDT)
Subject: Re: [bcmdhd] Retransmission packet
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Matteo <matteo.danieletto@gmail.com>
In-Reply-To: <51AF3CEA.1000409@broadcom.com>
Date: Wed, 5 Jun 2013 22:21:40 +0200
Cc: brcm80211-dev-list@broadcom.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <364B7072-08EF-4B28-ACCB-C7E072FB2866@gmail.com> (sfid-20130605_222147_583439_06853243)
References: <92D01B34-EB7E-47BA-ABD1-1C85B366ED47@gmail.com> <51AEFBD6.3000100@broadcom.com> <7CCB4989-196D-421E-BE73-1EF52F25C381@gmail.com> <51AF3CEA.1000409@broadcom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, on Android. From my point of view is hard to find a tablet/smartphone with a driver supports ad-hoc mode.
 With the driver b43 driver and ath5k I could find the retx count.

Do you know any website where I can find the chipset on board smartphones and tablets?

Thanks
Matteo

On Jun 5, 2013, at 3:28 PM, "Arend van Spriel" <arend@broadcom.com> wrote:

> + linux-wireless
> 
> On 06/05/2013 02:04 PM, Matteo wrote:
>> Hi Arend,
>> thank a lot.
>> 
>> yea, I wanted to find the retransmissions of the frame over the air.
>> I don't know, if other devices (broadcom or atheros) could give that information.
> 
> On Android? I guess any mac80211 based driver could give you that information. The information is provided by the driver to mac80211 upon txstatus using struct ieee80211_tx_info::status. The rates field should contain the rates at which the transmits were attempted and how often (see explanation of struct 	).
> 
> Regards,
> Arend
> 
>> Thanks again
>> Matteo
>> 
>> On Jun 5, 2013, at 10:50 AM, "Arend van Spriel" <arend@broadcom.com> wrote:
>> 
>>> - linux-wireless@vger.kernel.org
>>> 
>>> bcmdhd is not an upstream linux driver so removing that mailing list address.
>>> 
>>> On 06/04/2013 11:20 PM, Matteo Danieletto wrote:
>>>> Hi all,
>>>> 
>>>> I am trying to extract the number of retransmissions frame occur during
>>>> data transfer between two nodes.
>>> 
>>> I suppose you want the know the retransmissions of the frame over the air. The retries in the code below are over the bus between host and device. So that is not the information you want (right?).
>>> 
>>> The bad news is that the information is not available in the driver.
>>> 
>>> Regards,
>>> Arend
>>> 
>>>> I found in did_sdio.c this function:
>>>> 
>>>> 1. /* Writes a HW/SW header into the packet and sends it. */
>>>> 2. /* Assumes: (a) header space already there, (b) caller holds lock */
>>>> 3. staticint
>>>> 4. dhdsdio_txpkt(dhd_bus_t *bus,void*pkt,uint chan,boolfree_pkt)
>>>> 
>>>> 
>>>> .
>>>> .
>>>> .
>>>> there is this part:
>>>> 
>>>> 1. do{
>>>> 2.                  ret
>>>>    =dhd_bcmsdh_send_buf(bus,bcmsdh_cur_sbwad(sdh),SDIO_FUNC_2,F2SYNC,
>>>> 3.                                            frame,len,pkt,NULL,NULL);
>>>> 4.                  bus->f2txdata++;
>>>> 5.                  ASSERT(ret !=BCME_PENDING);
>>>> 6.
>>>> 
>>>> 7. if(ret <0){
>>>> 8. /* On failure, abort the command and terminate the frame */
>>>> 9.                          DHD_INFO(("%s: sdio error %d, abort command
>>>>    and terminate frame.\n",
>>>> 10.                                    __FUNCTION__,ret));
>>>> 11.                          bus->tx_sderrs++;
>>>> 12.
>>>> 
>>>> 13.                          bcmsdh_abort(sdh,SDIO_FUNC_2);
>>>> 14.
>>>>    bcmsdh_cfg_write(sdh,SDIO_FUNC_1,SBSDIO_FUNC1_FRAMECTRL,
>>>> 15.                                           SFC_WF_TERM,NULL);
>>>> 16.                          bus->f1regdata++;
>>>> 17.
>>>> 
>>>> 18. for(i =0;i <3;i++){
>>>> 19.                                  uint8 hi,lo;
>>>> 20.                                  hi =bcmsdh_cfg_read(sdh,SDIO_FUNC_1,
>>>> 21.
>>>>      SBSDIO_FUNC1_WFRAMEBCHI,NULL);
>>>> 22.                                  lo =bcmsdh_cfg_read(sdh,SDIO_FUNC_1,
>>>> 23.
>>>>      SBSDIO_FUNC1_WFRAMEBCLO,NULL);
>>>> 24.                                  bus->f1regdata +=2;
>>>> 25. if((hi ==0)&&(lo ==0))
>>>> 26. break;
>>>> 27. }
>>>> 28.
>>>> 
>>>> 29. }
>>>> 30. if(ret ==0){
>>>> 31.                          bus->tx_seq =(bus->tx_seq
>>>>    +1)%SDPCM_SEQUENCE_WRAP;
>>>> 32. }
>>>> 33. }while((ret <0)&&retrydata &&retries++<TXRETRIES);
>>>> 
>>>> 
>>>> 
>>>> I exploited iperf to create a data stream between two nodes, but it
>>>> never occurred an incrementation of retries variable, then everytime
>>>> did_bcmsdh_send_buf returned 0.
>>>> 
>>>> So, I don't know if it is the right point to extract this information
>>>> and it never occurred a retransmission, or more it is not possible
>>>> extract what I want.
>>>> 
>>>> Thanks a lot
>>>> 
>>>> Matteo
>>>> 
>>>> 
>>> 
>>> 
>> 
>> 
> 
> 

