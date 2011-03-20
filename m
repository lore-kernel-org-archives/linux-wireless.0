Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53547 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1CTCo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 22:44:27 -0400
Received: by wya21 with SMTP id 21so4910788wya.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2011 19:44:26 -0700 (PDT)
Message-ID: <4D8569F1.40900@gmail.com>
Date: Sun, 20 Mar 2011 02:44:01 +0000
From: =?ISO-8859-1?Q?Carlos_Guimar=E3es?= <asc2.cemg@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Sending L2 frames
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Hi,

I'm trying to send a 802.11 MGMT Action Frame using nl80211. However, it 
always give me the error: *ERROR: -107 : Transport endpoint is not 
connected*. Everything seems right to me and I have no more ideas of 
what could be happening.

Another strange thing is that after the error I can not connect again 
with the nl80211 until I restart the program.

Thanks,
Carlos Guimarães

Next is the code I'm using to send the frame:

int send_action_frame(const char *interface, unsigned int freq,
                  const uint8 *dst, const uint8 *src,
                  const uint8 *bssid,
                  const uint8 *data, size_t data_len)
{
     struct nl_sock *nl_handle = NULL;
     struct nl_cache *nl_cache = NULL;
     struct genl_family *nl80211 = NULL;
     struct nl_msg *msg;
     int ret = -1;
     uint8 *buf;
     struct ieee80211_hdr *hdr;
     uint64 cookie;

     log(1, "nl80211: Send Action frame (ifindex=", interface,")");

     buf = (uint8 *)calloc(24 + data_len, sizeof(uint8));
     if (buf == NULL)
         return ret;
     memcpy(buf + 24, data, data_len);
     hdr = (struct ieee80211_hdr *) buf;
     hdr->frame_control = (0 << 2) | (13 << 4);
     uint8* addr = (uint8 *)calloc(6, sizeof(uint8));
     void *addr_bg = addr;
     memset(addr, 0, 1); addr++;
     memset(addr, 20, 1); addr++;
     memset(addr, 108, 1); addr++;
     memset(addr, 76, 1); addr++;
     memset(addr, 192, 1); addr++;
     memset(addr, 196, 1); addr++;


     memcpy(hdr->addr1, addr_bg, 6);
     memcpy(hdr->addr2, addr_bg, 6);
//    memcpy(hdr->addr2, "\x00\x24\x17\xa1\x38\x2a", 6);
     memcpy(hdr->addr3, addr_bg, 6);

     if (connect(interface,
                          (void **) &nl_handle,
                          (void **) &nl_cache,
                          (void **) &nl80211) < 0) {
         return -1;
     }
log(1, "nl80211: connect");
     msg = nlmsg_alloc();
     if (!msg) {
         disconnect(nl_handle);
         free(buf);
         return -1;
     }

     genlmsg_put(msg, 0, 0, genl_family_get_id(nl80211), 0, 0,
             NL80211_CMD_ACTION, 0);

     NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, if_nametoindex(interface));
     NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
     NLA_PUT(msg, NL80211_ATTR_FRAME, 24 + data_len, buf);
log(1, "nl80211: message a enviar");
     cookie = 0;
     ret = send_and_receive(nl_handle, msg, cookie_handler, &cookie);
     log(1, "nl80211: enviada");
//    ret = send_and_receive(nl_handle, msg, NULL, NULL);
     msg = NULL;
     if (ret) {
         log(1, "nl80211: Action command failed: ret=%d "
                "(%s)", ret, strerror(-ret));
         goto nla_put_failure;
     }
     log(1, "nl80211: Action TX command accepted; "
            "cookie 0x%llx", (long long unsigned int) cookie);

     ret = 0;

nla_put_failure:
             log(1, "failure: ", ret);
     free(buf);
     buf = NULL;
     disconnect(nl_handle);
     return ret;
}
