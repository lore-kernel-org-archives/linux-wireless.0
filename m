Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:59735 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3JGQRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:17:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] bluetooth: fix variable shadow warnings
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1381157810-15310-1-git-send-email-johannes@sipsolutions.net>
Date: Mon, 7 Oct 2013 18:17:40 +0200
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Message-Id: <2146D6C2-0C7B-4810-AAFB-D5DC2C938EF0@holtmann.org> (sfid-20131007_181728_339605_165A5583)
References: <1381157810-15310-1-git-send-email-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Sparse points out three places where variables are shadowed,
> rename two of the variables and remove the duplicate third.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> net/bluetooth/hci_event.c  | 12 +++++++-----
> net/bluetooth/l2cap_sock.c |  2 +-
> 2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 94aab73..b5a3736 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -1291,9 +1291,11 @@ static void hci_cs_remote_name_req(struct hci_dev *hdev, __u8 status)
> 		goto unlock;
> 
> 	if (!test_and_set_bit(HCI_CONN_AUTH_PEND, &conn->flags)) {
> -		struct hci_cp_auth_requested cp;
> -		cp.handle = __cpu_to_le16(conn->handle);
> -		hci_send_cmd(hdev, HCI_OP_AUTH_REQUESTED, sizeof(cp), &cp);
> +		struct hci_cp_auth_requested auth_req;

can you rename this to auth_cp. The code base uses cp for command parameters.

> +
> +		auth_req.handle = __cpu_to_le16(conn->handle);
> +		hci_send_cmd(hdev, HCI_OP_AUTH_REQUESTED,
> +			     sizeof(auth_req), &auth_req);
> 	}
> 
> unlock:
> @@ -3636,8 +3638,8 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
> 	skb_pull(skb, HCI_EVENT_HDR_SIZE);
> 
> 	if (hdev->sent_cmd && bt_cb(hdev->sent_cmd)->req.event == event) {
> -		struct hci_command_hdr *hdr = (void *) hdev->sent_cmd->data;
> -		u16 opcode = __le16_to_cpu(hdr->opcode);
> +		struct hci_command_hdr *cmd_hdr = (void *) hdev->sent_cmd->data;
> +		u16 opcode = __le16_to_cpu(cmd_hdr->opcode);
> 
> 		hci_req_cmd_complete(hdev, opcode, 0);
> 	}
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 0098af8..f07e25d 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -683,7 +683,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
> 		}
> 
> 		if (opt == BT_FLUSHABLE_OFF) {
> -			struct l2cap_conn *conn = chan->conn;
> +			conn = chan->conn;
> 			/* proceed further only when we have l2cap_conn and
> 			   No Flush support in the LM */
> 			if (!conn || !lmp_no_flush_capable(conn->hcon->hdev)) {

I would have personally put this into part into a separate patch, but this way is fine as well.

Regards

Marcel

