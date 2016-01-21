Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33830 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbcAULdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:33:09 -0500
Received: by mail-pa0-f66.google.com with SMTP id yy13so1622929pab.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:33:08 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 27/27] staging: wilc1000: remove over-commenting
Date: Thu, 21 Jan 2016 20:30:57 +0900
Message-Id: <1453375857-20645-28-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123323_983060_BCC06A72)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are over-commenting in wilc_msgqueue.h file. This comment is not
explain exactly what codes do and make checkpatch warning about "line
over 80 charcters". If necessary, comment will be added later with
preferred coding style.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.h | 66 --------------------------------
 1 file changed, 66 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 4f79ead..ddd09843 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -1,18 +1,8 @@
 #ifndef __WILC_MSG_QUEUE_H__
 #define __WILC_MSG_QUEUE_H__
 
-/*!
- *  @file	wilc_msgqueue.h
- *  @brief	Message Queue OS wrapper functionality
- *  @author	syounan
- *  @sa		wilc_oswrapper.h top level OS wrapper file
- *  @date	30 Aug 2010
- *  @version	1.0
- */
-
 #include <linux/semaphore.h>
 
-/* Message Queue type is a structure */
 struct message {
 	void *buf;
 	u32 len;
@@ -27,67 +17,11 @@ struct message_queue {
 	struct message *msg_list;
 };
 
-/*!
- *  @brief		Creates a new Message queue
- *  @details		Creates a new Message queue, if the feature
- *                              CONFIG_WILC_MSG_QUEUE_IPC_NAME is enabled and pstrAttrs->pcName
- *                              is not Null, then this message queue can be used for IPC with
- *                              any other message queue having the same name in the system
- *  @param[in,out]	pHandle handle to the message queue object
- *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating success/failure
- *  @author		syounan
- *  @date		30 Aug 2010
- *  @version		1.0
- */
 int wilc_mq_create(struct message_queue *mq);
-
-/*!
- *  @brief		Sends a message
- *  @details		Sends a message, this API will block until the message is
- *                              actually sent or until it is timedout (as long as the feature
- *                              CONFIG_WILC_MSG_QUEUE_TIMEOUT is enabled and pstrAttrs->u32Timeout
- *                              is not set to WILC_OS_INFINITY), zero timeout is a valid value
- *  @param[in]	pHandle handle to the message queue object
- *  @param[in]	pvSendBuffer pointer to the data to send
- *  @param[in]	u32SendBufferSize the size of the data to send
- *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating success/failure
- *  @author		syounan
- *  @date		30 Aug 2010
- *  @version		1.0
- */
 int wilc_mq_send(struct message_queue *mq,
 		 const void *send_buf, u32 send_buf_size);
-
-/*!
- *  @brief		Receives a message
- *  @details		Receives a message, this API will block until a message is
- *                              received or until it is timedout (as long as the feature
- *                              CONFIG_WILC_MSG_QUEUE_TIMEOUT is enabled and pstrAttrs->u32Timeout
- *                              is not set to WILC_OS_INFINITY), zero timeout is a valid value
- *  @param[in]	pHandle handle to the message queue object
- *  @param[out]	pvRecvBuffer pointer to a buffer to fill with the received message
- *  @param[in]	u32RecvBufferSize the size of the receive buffer
- *  @param[out]	pu32ReceivedLength the length of received data
- *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating success/failure
- *  @author		syounan
- *  @date		30 Aug 2010
- *  @version		1.0
- */
 int wilc_mq_recv(struct message_queue *mq,
 		 void *recv_buf, u32 recv_buf_size, u32 *recv_len);
-
-/*!
- *  @brief		Destroys an existing  Message queue
- *  @param[in]	pHandle handle to the message queue object
- *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating success/failure
- *  @author		syounan
- *  @date		30 Aug 2010
- *  @version		1.0
- */
 int wilc_mq_destroy(struct message_queue *mq);
 
 #endif
-- 
2.7.0

