Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53766 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab2FFBfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 21:35:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Sc59L-0005vF-Td
	for linux-wireless@vger.kernel.org; Wed, 06 Jun 2012 03:35:04 +0200
Received: from c-76-124-86-222.hsd1.pa.comcast.net ([76.124.86.222])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 03:35:03 +0200
Received: from anandaragorn by c-76-124-86-222.hsd1.pa.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 03:35:03 +0200
To: linux-wireless@vger.kernel.org
From: Anand <anandaragorn@gmail.com>
Subject: Constructing radiotap header and ieee80211 header structures
Date: Wed, 6 Jun 2012 01:31:20 +0000 (UTC)
Message-ID: <loom.20120606T032641-340@post.gmane.org> (sfid-20120606_033511_681078_EEB56ADF)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 am trying to communicate between two laptop machines using Wifi. 
The structure of the radiotap header 
and ieee80211 header i am using are

 struct ieee80211_radiotap_header {
unsigned char it_version;
uint16_t it_len;        
uint32_t it_present;
 };

 /* Structure for 80211 header */

 struct ieee80211_hdr_3addr {
    uint16_t frame_ctl[2];
    uint16_t duration_id;
    unsigned char addr1[ETH_ALEN];
    unsigned char addr2[ETH_ALEN];
    unsigned char addr3[ETH_ALEN];
    uint16_t seq_ctl;
  };

struct packet {
   struct ieee80211_radiotap_header rtap_header;
   struct ieee80211_hdr_3addr iee802_header;
   unsigned char payload[30];

  };

  /* In main program */

   struct packet mypacket;
   struct ieee80211_radiotap_header ratap_header;
   struct ieee80211_hdr_3addr iee802_header;

   unsigned char addr1[ETH_ALEN] = {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};  /* broadcast address */
   unsigned char addr2[ETH_ALEN] = {0x28,0xcf,0xda,0xde,0xd3,0xcc};  /* mac address of   
                                                                      network card */
   unsigned char addr3[ETH_ALEN] = {0xd8,0xc7,0xc8,0xd7,0x9f,0x21};   /* mac address of   
                                                  access point i am trying to connect to */


  /* Radio tap header data */
   ratap_header.it_version = 0x00;
   ratap_header.it_len = 0x07;      
   ratap_header.it_present =  (1 << IEEE80211_RADIOTAP_RATE);

   mypacket.rtap_header = ratap_header;

   /* ieee80211 header data */

    iee802_header.frame_ctl[0] = IEEE80211_FC0_VERSION_0  |
                                                   IEEE80211_FC0_TYPE_MGT | 
                                                    IEEE80211_FC0_SUBTYPE_BEACON;

   iee802_header.frame_ctl[1] =IEEE80211_FC1_DIR_NODS;
    strcpy(iee802_header.addr1,addr1);
    strcpy(iee802_header.addr2,addr2);
    strcpy(iee802_header.addr3,addr3);
    iee802_header.seq_ctl = 0x1086;

    mypacket.iee802_header=iee802_header;

   /* Payload */

   unsigned char payload[PACKET_LENGTH]="temp";

   strcpy(mypacket.payload , payload);

I am able to receive the packets when i test the transmission 
and reception on the same laptop. However i 
am not able to receive the packet transmitted on a 
different laptop. Wireshark does not show the packet 
as well. Can anyone point out the mistake i am making?

